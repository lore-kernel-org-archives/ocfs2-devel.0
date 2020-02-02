From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 2 Feb 2020 17:01:25 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove trivial nowait check for
 buffered read/write
In-Reply-To: <1580541178-7853-1-git-send-email-qiwuchen55@gmail.com>
References: <1580541178-7853-1-git-send-email-qiwuchen55@gmail.com>
Message-ID: <64ca27c4-c3ee-2a43-3d97-35ad55e11472@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 20/2/1 15:12, qiwuchen55 at gmail.com wrote:
> From: chenqiwu <chenqiwu@xiaomi.com>
> 
> Remove trivial nowait check for buffered read/write, since
> buffered read is checked in generic_file_read_iter()->
> generic_file_buffered_read(), buffered write is checked in
> generic_write_checks().
> 
You are right, but check it at the beginning of
ocfs2_file_[read|write]_iter() will save much effort for lock ops, so
I'd like to leave them there.

Thanks,
Joseph
