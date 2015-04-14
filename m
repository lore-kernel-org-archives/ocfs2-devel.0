From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 14 Apr 2015 11:06:40 +0800
Subject: [Ocfs2-devel] Question about commit cf1b5ea1c5cd
Message-ID: <552C8440.2000106@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Viro,
I have questions about your commit cf1b5ea1c5cd
("[regression] ocfs2: do *not* increment ->ki_pos twice").
Yes, ->ki_pos is increased in generic_file_direct_write(). But
*ppos doesn't. So I increase it here for further use in
generic_perform_write.
After this, ->ki_pos and *ppos are equal. Then after buffer write, I
only get written_buffered increased into ->ki_pos, so ->ki_pos is *not*
increased twice.
