From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 12 Nov 2015 11:05:44 +0800
Subject: [Ocfs2-devel] Long io response time doubt
Message-ID: <56440208.7070809@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,
You reported an issue about sometime io response time may be long.

From your test case information, I think it was caused by downconvert.
And it seemed reasonable because it had to.

Node 1 wrote file, and node 2 read it. Since you used buffer io, that
was after node 1 had finished written, it might be still in page cache.
So node 1 should downconvert first then node 2 read could continue.
That was why you said it seemed ocfs2_inode_lock_with_page spent most
time. More specifically, it was ocfs2_inode_lock after trying nonblock
lock and returning -EAGAIN.

And this also explained why direct io didn't have the issue, but took
more time.

I am not sure if your test case is the same as what the customer has
reported. I think you should recheck the operations in each node.

And we have reported an case before about DLM handling issue. I am not
sure if it has relations.
https://oss.oracle.com/pipermail/ocfs2-devel/2015-August/011045.html
