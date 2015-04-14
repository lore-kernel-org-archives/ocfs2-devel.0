From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 14 Apr 2015 11:00:09 +0800
Subject: [Ocfs2-devel] A question about function jbd2__journal_restart()
Message-ID: <552C82B9.7060305@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

Hi all,
I have a question about function jbd2__journal_restart().
If we call this function when there's not more credits,
it may commit the handle's transaction and start another one.
So a handle can be attached to 2 transaction and can not ensure the
consistency. It is the caller's responsibility to keep things consistently
before call jbd2__journal_restart(), right?

Thanks very much.
