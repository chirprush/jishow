from time import sleep
import grequests

def to_lua_list(l, f, whitespace, start_whitespace="", end_whitespace="") -> str:
    return "{" + start_whitespace + (',' + whitespace).join(map(f, l)) + end_whitespace + "}"

class Entry:
    def __init__(self, json) -> None:
        self.kanji = json["kanji"]
        self.kun = json["kun_readings"]
        self.on = json["on_readings"]
        self.meanings = json["meanings"]

    def to_lua(self) -> str:
        kanji = repr(self.kanji)
        kun = to_lua_list(self.kun, repr, " ")
        on = to_lua_list(self.on, repr, " ")
        meanings = to_lua_list(self.meanings, repr, " ")
        return f"{{\n      kanji = {kanji},\n      kun = {kun},\n      on = {on},\n      meanings = {meanings}\n   }}"

def entries_to_lua(entries) -> str:
    return to_lua_list(entries, lambda entry: "   " + entry.to_lua(), "\n", "\n", "\n")

data = grequests.map([grequests.get("https://kanjiapi.dev/v1/kanji/joyo")])[0].json()
responses = grequests.map((grequests.get(f"https://kanjiapi.dev/v1/kanji/{kanji}") for kanji in data), size=8)

entries = [Entry(response.json()) for response in responses]

print("return " + entries_to_lua(entries))
