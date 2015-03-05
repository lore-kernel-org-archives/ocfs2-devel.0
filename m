From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Thu, 5 Mar 2015 18:36:39 +0900
Subject: [Ocfs2-devel] [PATCH 1/4 V2] ocfs2: use retval instead of
	status for checking error
In-Reply-To: <CAHb8M2CjHi98k825GgBE2g_0WL1a6H+OdDSxCpJFJj_qenD14g@mail.gmail.com>
References: <20150227234840.GA12922@devel.8.8.4.4> <54F42797.1040908@nod.at>
	<CAHb8M2CjHi98k825GgBE2g_0WL1a6H+OdDSxCpJFJj_qenD14g@mail.gmail.com>
Message-ID: <CAHb8M2DyVvNbvX3tQ0zKxhm07A=DWCax5RNt+Xp=dZK95RuL4A@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mfasheh@suse.com, Richard Weinberger <richard@nod.at>, Joel Becker <jlbec@evilplan.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>

Hi,

How is this patch going on?

please check for me.

Thanks.
Daeseok Youn.

2015-03-03 10:38 GMT+09:00 DaeSeok Youn <daeseok.youn@gmail.com>:
> Hi, all
>
> please, review this patch.
>
> thanks.
>
> regards,
> Daeseok Youn.
>
> 2015-03-02 18:04 GMT+09:00 Richard Weinberger <richard@nod.at>:
>> Am 28.02.2015 um 00:48 schrieb Daeseok Youn:
>>> The use of 'status' in __ocfs2_add_entry() can return wrong
>>> status when some functions are failed.
>>>
>>> If ocfs2_journal_access_db() in __ocfs2_add_entry() is failed,
>>> that status is saved to 'status' but return variable is 'retval'
>>> which is saved 'success' status. In case of this,  __ocfs2_add_entry()
>>> is failed but can be returned as 'success'.
>>>
>>> So replace 'status' with 'retval'.
>>
>> As this patch is untested and the issue is theoretical I'm nervous.
>> But the final decision is up to ocfs2 maintainers.
>>
>> Thanks,
>> //richard
