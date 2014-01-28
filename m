From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 28 Jan 2014 17:53:05 +0800
Subject: [Ocfs2-devel] [RFD] ocfs2: poor performance on append write/punch
	hole
Message-ID: <52E77E01.9010902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_file_aio_write, it will fall back to buffered IO when cannot
complete direct IO request, e.g. append write and punch hole. And mostly
it should firstly do space allocation and this will make much more
journal to flush.
From test, we found the above two cases performs almost 70% lower than
normal case(allocate space first and overwrite). Furthermore, it spends
more than 90% time on jbd2_journal_force_commit during aio write.

So if anyone have an idea on how to tune the performance on these two cases?
