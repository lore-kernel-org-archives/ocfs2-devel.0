From: Likai <li.kai4@h3c.com>
Date: Thu, 6 Feb 2020 09:53:54 +0000
Subject: [Ocfs2-devel] [QUESTION] A problem about calling journal flush
 to mark journal as empty after journal recovery when mount
References: <b05e6190-c9e9-5151-5f04-c39d863a6316@huawei.com>
Message-ID: <c1fc3359eb954def8ad3b23eea33d39f@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2020/2/6 17:24, wangyan wrote:
> Hi all,
>
> I met a problem when I applied this patch:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_torvalds_linux_commit_397eac17f86f404f5ba31d8c3e39ec3124b39fd3&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=6mOuSCY0uVj1EQsCulE745DiAdBp7k1dPPfLsJC72ws&s=FO5NwgZUjnfd_fnVyVGu8h-qRlrJcjAr7LF6GdbrhHA&e= 
>
> It didn't update jbd2 sb log tail when mount as follows:
> ocfs2_journal_load
> 	->jbd2_journal_load
> 		->journal_reset
> 			->journal->j_tail_sequence = journal->j_transaction_sequence;
> 	->jbd2_journal_flush
> 		->jbd2_cleanup_journal_tail
> 			->jbd2_journal_get_log_tail // if ret is 0, it will return 1
> 				->*tid = journal->j_transaction_sequence;
> 				->*block = journal->j_head;
> 				/* ret is 0 due to "*tid == journal->j_tail_sequence */
> 				->ret = tid_gt(*tid, journal->j_tail_sequence);
> 			->__jbd2_update_log_tail // cann't not reach this place
>
> How does this patch solve the problem mentioned
> in this patch by calling jbd2_journal_flush?
>
> Thanks,
> Yan Wang
>
>
jbd2_journal_flush->jbd2_mark_journal_empty will work.

Thanks
