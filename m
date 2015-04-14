From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 14 Apr 2015 04:40:10 +0100
Subject: [Ocfs2-devel] Question about commit cf1b5ea1c5cd
In-Reply-To: <552C8440.2000106@huawei.com>
References: <552C8440.2000106@huawei.com>
Message-ID: <20150414034009.GV889@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 14, 2015 at 11:06:40AM +0800, Joseph Qi wrote:
> Hi Viro,
> I have questions about your commit cf1b5ea1c5cd
> ("[regression] ocfs2: do *not* increment ->ki_pos twice").
> Yes, ->ki_pos is increased in generic_file_direct_write(). But
> *ppos doesn't. So I increase it here for further use in
> generic_perform_write.
> After this, ->ki_pos and *ppos are equal.

They are equal all along, for a very simple reason: ppos *points* *to*
iocb->ki_pos.  So yes, you do increase it twice, once via one alias,
once via another.

Check and you'll see - ppos is initialized with &iocb->ki_pos and never
reassigned.  What happens is an equivalent of

int x = 0;
int *p = &x;

x += 10;
*p += 10;

which obviously ends with x increased by 20, not by 10...
