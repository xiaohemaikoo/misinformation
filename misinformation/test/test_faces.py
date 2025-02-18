import misinformation.faces as fc
import json
from pytest import approx


def test_analyse_faces():
    mydict = {
        "filename": "./test/data/IMG_2746.png",
    }
    mydict = fc.EmotionDetector(mydict).analyse_image()
    print(mydict)

    with open("./test/data/example_faces.json", "r") as file:
        out_dict = json.load(file)

    for key in mydict.keys():
        if key != "emotion":
            assert mydict[key] == out_dict[key]
    # json can't handle tuples natively
    for i in range(0, len(mydict["emotion"])):
        temp = (
            list(mydict["emotion"][i])
            if type(mydict["emotion"][i]) == tuple
            else mydict["emotion"][i]
        )
        assert approx(temp) == out_dict["emotion"][i]
