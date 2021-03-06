//
//  TSDraftMorePopView.swift
//  ThinkSNS +
//
//  Created by 小唐 on 04/01/2018.
//  Copyright © 2018 ZhiYiCX. All rights reserved.
//
//  草稿的更多选项弹窗视图

import Foundation

protocol TSDraftMorePopViewProtocol: class {
    /// 编辑草稿点击回调
    func didClicKUpdateDraftInDraftPopView(_ popView: TSDraftMorePopView) -> Void
    /// 删除草稿点击回调
    func didClickDeleteDraftInDraftPopView(_ popView: TSDraftMorePopView) -> Void
    /// 查看问题点击回调
    func didClickViewQuestionInDraftPopView(_ popView: TSDraftMorePopView) -> Void
    /// 遮罩点击回调
    func didClickCoverInDraftPopView(_ popView: TSDraftMorePopView) -> Void
}
extension TSDraftMorePopViewProtocol {
    /// 遮罩点击响应
    func didClickCoverInDraftPopView(_ popView: TSDraftMorePopView) -> Void {
    }
}

class TSDraftMorePopView: UIView {

    // MARK: - Internal Property
    /// 回调
    weak var delegate: TSDraftMorePopViewProtocol?
    /// 类型
    let type: TSDraftType
    // MARK: - Internal Function

    // MARK: - Private Property
    /// 用户按钮的顶部间距
    private let topMargin: CGFloat
    private let rightMargin: CGFloat
    private weak var coverBtn: UIButton!

    // MARK: - Initialize Function
    init(topMargin: CGFloat, rightMargin: CGFloat, type: TSDraftType) {
        self.type = type
        self.topMargin = topMargin
        self.rightMargin = rightMargin
        super.init(frame: CGRect.zero)
        self.initialUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCircle Function

    // MARK: - Private  UI

    // 界面布局
    private func initialUI() -> Void {
        let optionH: CGFloat = 40
        let optionW: CGFloat = 80
        // 1. coverBtn
        let coverBtn = UIButton(type: .custom)
        self.addSubview(coverBtn)
        coverBtn.addTarget(self, action: #selector(coverBtnClick(_:)), for: .touchUpInside)
        coverBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.coverBtn = coverBtn
        // 2. 草稿处理：编辑问题、删除
        let draftOptionView = UIView(cornerRadius: 5, borderWidth: 0.5, borderColor: TSColor.normal.disabled)
        coverBtn.addSubview(draftOptionView)
        draftOptionView.backgroundColor = UIColor.white
        draftOptionView.snp.makeConstraints { (make) in
            make.trailing.equalTo(coverBtn).offset(-self.rightMargin)
            make.width.equalTo(optionW)
            // 距离顶部的高度修正，使其能因topMargin传的值过大时能超上显示。
            // 该popView显示在self.view上面
            // moreH，更多按钮的高度，这里直接拷贝过来，最好是传递过来。
            let height: CGFloat = optionH * 2.0
            let moreH: CGFloat = CGFloat(12 + 15 * 2)
            let realTopMargin: CGFloat = (topMargin + height > ScreenHeight - 64.0 - 44.0) ? topMargin - moreH - height : topMargin
            make.top.equalTo(coverBtn).offset(realTopMargin)
        }
        // 2.x 响应子选项
        var titles: [String] = [String]()
        switch self.type {
        case .question:
            titles = ["编辑问题", "删 除"]
        case .answer:
            titles = ["查看问题", "删 除"]
        case .post:
            titles = ["编辑帖子", "删 除"]
        }
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            draftOptionView.addSubview(button)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitleColor(TSColor.normal.content, for: .normal)
            button.tag = 250 + index
            button.addTarget(self, action: #selector(draftOptionClick(_:)), for: .touchUpInside)
            button.snp.makeConstraints({ (make) in
                make.leading.trailing.equalTo(draftOptionView)
                make.height.equalTo(optionH)
                make.top.equalTo(draftOptionView).offset(optionH * CGFloat(index))
                if index == titles.count - 1 {
                    make.bottom.equalTo(draftOptionView)
                }
            })
            if index != titles.count - 1 {
                button.addLineWithSide(.inBottom, color: TSColor.normal.disabled, thickness: 0.5, margin1: 0, margin2: 0)
            }
        }
    }

    // MARK: - Private  数据加载

    // MARK: - Private  事件响应

    /// 遮罩点击响应
    @objc private func coverBtnClick(_ button: UIButton) -> Void {
        self.removeFromSuperview()
        self.delegate?.didClickCoverInDraftPopView(self)
    }
    // 草稿选项点击响应
    @objc private func draftOptionClick(_ button: UIButton) -> Void {
        self.removeFromSuperview()
        guard let title = button.currentTitle else {
            return
        }
        switch title {
        case "编辑问题":
            fallthrough
        case "编辑帖子":
            self.delegate?.didClicKUpdateDraftInDraftPopView(self)
        case "查看问题":
            self.delegate?.didClickViewQuestionInDraftPopView(self)
        case "删 除":
            self.delegate?.didClickDeleteDraftInDraftPopView(self)
        default:
            break
        }
    }
}
