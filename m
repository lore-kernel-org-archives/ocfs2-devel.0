From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 10 Feb 2017 06:01:13 +0000
Subject: [Ocfs2-devel] [RFC] Should we revert commit "ocfs2: do not
 lock/unlock() inode DLM lock"
Message-ID: <63ADC13FD55D6546B7DECE290D39E37342E78EEA@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, Joseph Qi <jiangqi903@gmail.com>, "Eric Ren (zren@suse.com)" <zren@suse.com>, Mark Fasheh <mfasheh@versity.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, "\"Andrew Morton (akpm\"@linux-foundation.org" <"Andrew Morton (akpm"@linux-foundation.org>

Hi,
We encountered a LIVELOCK problem while performing a test case of
high-concurrency read between different nodes.
It's very easy to reproduce this issue.
Just perform high-concurrency read operation against one single large
file (say named test_file) from one physical node,
meanwhile, perform "chmod o+w test_file" from another node.

In my case of reproducing this issue, I make use of bench mark tool
"vdbench",
I believe any other bench mark tools or workload  generators will work, too!
Make sure the file is large enough and most of it is cached in main memory.
Then perform "chmod o+w test_file" from another node.


Node 1                                                              Node 2
Perform high-concurrency read
under non-direct IO

Wait for a while so that most portion
of file can be cached.

Perform "chmod o+w test_file"

After that the whole cluster will hang due to a LIVELOCK problem which
acts like DC worker has no enough capability to truncate all pages due
to newly allocated pages or MM's retry mechanism.

[<ffffffff8118919e>] __lock_page+0xae/0xb0
[<ffffffff8119a936>] truncate_inode_pages_range+0x446/0x700
[<ffffffff8119ac75>] truncate_inode_pages+0x15/0x20
[<ffffffffc0756102>] ocfs2_data_convert_worker+0x192/0x1a0 [ocfs2]
[<ffffffffc0758c00>] ocfs2_process_blocked_lock+0x270/0x950 [ocfs2]
[<ffffffffc0759811>] ocfs2_downconvert_thread+0x121/0x250 [ocfs2]
[<ffffffff8109e069>] kthread+0xc9/0xe0
[<ffffffff817f85e2>] ret_from_fork+0x42/0x70
[<ffffffffffffffff>] 0xffffffffffffffff

I believe this issue is introduced by patch "ocfs2: do not lock/unlock()
inode DLM lock".
In this patch, it removed blocked-way DLM lock acquisition, thus, DC
worker may have not enough time to truncate all pages before newly
allocated pages and MM's retry for read.

Should we just revert this commit giving DC worker enough time to
truncate all pages, thus, others nodes will not wait local node's down
conversion completion.
And this LIVELOCK issue will be solved for best.

Br.
Thanks.
Changwei.
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
