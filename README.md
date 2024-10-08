# delphi_lost
很多delphi控件都不再维护了,这里收集一些我用过的经人在官方版本上维护过的能用的版本,当然相当一部分是我自己写的

[注意，主要用于 delphi7]

一些小的东西，不过可以组合生成一些非常好的效果，例子可以看我们的 "文本处理大师 迷你版"（注意不是标准版本）和 "eEmail"


# TGIFImage

加入了第三方的 TGIFImage 控件。不知为何网上 d7 版本的 TGIFImage 控件最新的虽然都是 2.2 版本，但代码并不相同。
这种情况我已经碰到两次了，因此放一个版本上来。据说 TGIFImage 更高的版本已经是收费的了，并且已经收录到正式的 delphi 最新版本之中了。

# mormot 不收录的原因

mormot 问题是很多的，但功能强大。因此我也魔改有它的特别版本，当时是 1.8 。最近去看发现它已经升级到 2.0 了，好用是好用，兼容性也比 1.8 好不少，但今日发现的一个问题让我最终还是放弃了它。
不过 mormot 的很多功能的实现方式可以用作参考。mormot 作为这么大名气的控件 bug 得如此明显实在是可叹，让我想起了多年前被人口诛笔伐的 indy 控件。我觉得 delphi 的衰落和它的控件质量实在不太高也是有很大关系的。

好了，具体的问题在于（lazarus 3.2 windows 版本下）
//mormot.core.variants,  //奇怪，只要项目中有这个文件就会破坏 FindFirst 的结果  //这是因为 mormot 重新定向了 _ansistr_concat_multi_utf8 替换 fpc_ansistr_concat_multi
  //参考 mormot.core.rtti.fpc.inc 中的 RedirectCode(@fpc_ansistr_concat_multi, @_ansistr_concat_multi_utf8);
  //这个代码明显是替换了它的函数，实在是太可怕了，出错也是应该的 //这是 2.0 的问题，不知道 1.8 有没有 



