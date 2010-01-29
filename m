From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Fri, 29 Jan 2010 15:09:04 +0300
Subject: [Ocfs2-devel] 2.6.32.6: ocfs2rec hungs
Message-ID: <a4423d671001290409s21be23c7y94b1c1896fd644e0@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi

Does it look new for you? Open a bug?


(7414,0):o2net_connect_expired:1656 ERROR: no connection established
with node 8 after 30.0 seconds, giving up and returning errors.
(7491,0):o2dlm_eviction_cb:269 o2dlm has evicted node 8 from group
27C2BDDDBEA14CCEA6AA50A5B424C8E5
(7414,0):o2dlm_eviction_cb:269 o2dlm has evicted node 8 from group
27C2BDDDBEA14CCEA6AA50A5B424C8E5
INFO: task ocfs2rec:14896 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ocfs2rec      D f597b800     0 14896      2 0x00000000
 f5a10370 00000046 c101f04a f597b800 00000400 f5a60214 00000400 f5a60214
 f909a279 f6b74a00 00000000 f5a104f8 00000001 c101e925 00000000 00000000
 7fffffff f4db5ef0 f4db5e5c 7fffffff c12544fa 00000002 00000000 0000d7c7
Call Trace:
 [<c101f04a>] ? wakeup_gran+0x3b/0x54
 [<f909a279>] ? dlmlock+0xe9/0xe20 [ocfs2_dlm]
 [<c101e925>] ? wake_affine+0x48/0x11b
 [<c12544fa>] ? schedule_timeout+0x17a/0x183
 [<c101f04a>] ? wakeup_gran+0x3b/0x54
 [<c12540c7>] ? wait_for_common+0x96/0x121
 [<c1023c1d>] ? default_wake_function+0x0/0x8
 [<f90d308f>] ? o2dlm_lock_ast_wrapper+0x0/0x13 [ocfs2_stack_o2cb]
 [<c1023c1d>] ? default_wake_function+0x0/0x8
 [<f97eb42e>] ? ocfs2_wait_for_mask+0xb/0x17 [ocfs2]
 [<f97eb682>] ? __ocfs2_cluster_lock+0x16a/0x96a [ocfs2]
 [<f97ef4b3>] ? ocfs2_super_lock+0x8e/0x481 [ocfs2]
 [<f9806da9>] ? __ocfs2_recovery_thread+0x96/0x87e [ocfs2]
 [<f9806d13>] ? __ocfs2_recovery_thread+0x0/0x87e [ocfs2]
 [<f9806da9>] ? __ocfs2_recovery_thread+0x96/0x87e [ocfs2]
 [<c1253d31>] ? schedule+0x1b1/0x4b1
 [<c1023c5f>] ? __wake_up_common+0x3a/0x66
 [<f9806d13>] ? __ocfs2_recovery_thread+0x0/0x87e [ocfs2]
 [<c1023db6>] ? complete+0x37/0x46
 [<f9806d13>] ? __ocfs2_recovery_thread+0x0/0x87e [ocfs2]
 [<c1038fa8>] ? kthread+0x68/0x6d
 [<c1038f40>] ? kthread+0x0/0x6d
 [<c100369f>] ? kernel_thread_helper+0x7/0x18
