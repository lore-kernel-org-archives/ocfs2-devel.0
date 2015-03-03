From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Tue, 3 Mar 2015 10:38:31 +0900
Subject: [Ocfs2-devel] [PATCH 1/4 V2] ocfs2: use retval instead of
	status for checking error
In-Reply-To: <54F42797.1040908@nod.at>
References: <20150227234840.GA12922@devel.8.8.4.4>
	<54F42797.1040908@nod.at>
Message-ID: <CAHb8M2CjHi98k825GgBE2g_0WL1a6H+OdDSxCpJFJj_qenD14g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: mfasheh@suse.com, Andrew Morton <akpm@linux-foundation.org>, Joel Becker <jlbec@evilplan.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>

Hi, all

please, review this patch.

thanks.

regards,
Daeseok Youn.

2015-03-02 18:04 GMT+09:00 Richard Weinberger <richard@nod.at>:
> Am 28.02.2015 um 00:48 schrieb Daeseok Youn:
>> The use of 'status' in __ocfs2_add_entry() can return wrong
>> status when some functions are failed.
>>
>> If ocfs2_journal_access_db() in __ocfs2_add_entry() is failed,
>> that status is saved to 'status' but return variable is 'retval'
>> which is saved 'success' status. In case of this,  __ocfs2_add_entry()
>> is failed but can be returned as 'success'.
>>
>> So replace 'status' with 'retval'.
>
> As this patch is untested and the issue is theoretical I'm nervous.
> But the final decision is up to ocfs2 maintainers.
>
> Thanks,
> //richard
