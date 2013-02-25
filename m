From: Smart Weblications GmbH - Florian Wiessner <f.wiessner@smart-weblications.de>
Date: Mon, 25 Feb 2013 22:37:15 +0100
Subject: [Ocfs2-devel] OCFS2 mainline state?
In-Reply-To: <512BCA9E.4090702@nod.at>
References: <512BCA9E.4090702@nod.at>
Message-ID: <512BD98B.8070202@smart-weblications.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: ocfs2-devel@oss.oracle.com, ocfs2-user@oss.oracle.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, mfasheh@suse.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, david@sigma-star.at

Am 25.02.2013 21:33, schrieb Richard Weinberger:
> Hi!
> 
> Today I encountered the following problem on v3.8:
> [   28.940032] general protection fault: 0000 [#1] PREEMPT SMP
> ...
> [   28.984953] Call Trace:
> [   28.986628   [<ffffffffa04cb200>] ocfs2_fast_symlink_readpage+0x70/0x1b0 [ocfs2]
> [   28.988302]  [<ffffffff8110dc49>] ? add_to_page_cache_lru+0x29/0x40
> [   28.989942]  [<ffffffff8110ddca>] do_read_cache_page+0x7a/0x170
> [   28.991573]  [<ffffffff8110def4>] read_cache_page_async+0x14/0x20
> [   28.993212]  [<ffffffff8110df09>] read_cache_page+0x9/0x20
> [   28.994827]  [<ffffffff81170ae5>] page_getlink.isra.9+0x25/0x80
> [   28.996442]  [<ffffffff81170b61>] page_follow_link_light+0x21/0x40
> [   28.998049]  [<ffffffff8117090d>] generic_readlink+0x3d/0xa0
> [   28.999653]  [<ffffffff8116c0db>] sys_readlinkat+0xfb/0x130
> [   29.001246]  [<ffffffff8116c126>] sys_readlink+0x16/0x20
> [   29.002839]  [<ffffffff815d8dad>] system_call_fastpath+0x1a/0x1f
> 
> To my utter astonishment I found out that the issue is known since August 2012.
> And there is also a trivial fix for it.[0]
> The said fix found it's way into Oracle Unbreakable Linux very quickly,
> but not into mainline.[1]
> 
> Now I'm wondering how much Oracle really cares about OCFS2 in mainline?
> Maybe there are some more unfixed vulnerabilities?
> 

I noticed and reported this on 07.02.2013 but got no reply ;(


-- 

Mit freundlichen Gr??en,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Gesch?ftsf?hrer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
-------------- next part --------------
An embedded message was scrubbed...
From: Smart Weblications GmbH - Florian Wiessner
	<f.wiessner@smart-weblications.de>
Subject: problem with ocfs2 in 3.7.6 and 3.6.11
Date: Thu, 07 Feb 2013 03:04:27 +0100
Size: 10611
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130225/09e255b0/attachment-0001.mht 
