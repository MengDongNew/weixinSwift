// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var localList = [
    "石家庄", "北京", "石家庄", "上海", "广州", "郑州", "石家庄"
]
var numsList = [
    12, 23, 12, 24, 34, 25
]

//泛型使用方法
func getRemovedIndexs<T: Equatable>(fromValue: T, fromArray:[T]) -> [Int] {
    var indexsAry = [Int]()
    //正确索引数组
    var correctIndexsAry = [Int]()
    //获取原始的索引，并添加到数组中
    for (index, value) in enumerate(fromArray) {
        if value == fromValue {
            indexsAry.append(index)
        }
    }
    //
    for (index, orignIndexValue) in enumerate(indexsAry) {
        //获取正确的索引
        var correctIndex = orignIndexValue - index
        //将正确的索引添加到数组中
        correctIndexsAry.append(correctIndex)
    }
    return correctIndexsAry
}

func removeValue<T: Equatable>(value:T, inout fromArray:[T]) {
    //正确索引数组
    var correctIndexsAry = getRemovedIndexs(value, fromArray)
    //
    for index in correctIndexsAry {
        fromArray.removeAtIndex(index)
    }
}

removeValue("石家庄", &localList)
removeValue(12, &numsList)

