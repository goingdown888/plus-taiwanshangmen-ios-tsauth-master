//
//  TSWalletHistoryObject.swift
//  ThinkSNS +
//
//  Created by GorCat on 2017/6/5.
//  Copyright © 2017年 ZhiYiCX. All rights reserved.
//
//  提现明细 数据库数据结构

import UIKit
import RealmSwift

class TSWithdrawHistoryObject: Object {

    /// 提现记录 id
    @objc dynamic var id = -1
    /// 提现金额
    @objc dynamic var value = -1
    /// 提现方式
    @objc dynamic  var type = ""
    /// 提现账户
    @objc dynamic  var account = ""
    /// 提现状态， 0 - 待审批，1 - 已审批，2 - 被拒绝
    @objc dynamic var status = -1
    /// 备注，审批或者拒绝的时候由管理填写
    @objc dynamic var remark: String?
    /// 申请时间
    @objc dynamic var create = NSDate()

    /// 设置索引
    override static func indexedProperties() -> [String] {
        return ["id"]
    }

    /// 设置主键
    override static func primaryKey() -> String? {
        return "id"
    }
}
