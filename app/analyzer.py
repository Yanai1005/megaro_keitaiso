import fugashi
import ipadic

class MorphologicalAnalyzer:
    def __init__(self):
        # ipadicのパスを明示指定（Nix環境でも確実に動作）
        self.tagger = fugashi.GenericTagger(ipadic.MECAB_ARGS)

    def parse(self, text: str) -> list[list[str]]:
        tokens = []
        for word in self.tagger(text):
            features = word.feature
            token = [
                word.surface,
                features[7] if len(features) > 7 and features[7] != "*" else word.surface,
                features[6] if len(features) > 6 and features[6] != "*" else word.surface,
                features[0],
                features[1],
                features[4] if len(features) > 4 and features[4] != "*" else "*",
                features[5] if len(features) > 5 and features[5] != "*" else "*",
            ]
            tokens.append(token)
        return tokens

analyzer = MorphologicalAnalyzer()