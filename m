From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 8 Mar 2010 21:29:04 +0800
Subject: [Ocfs2-devel] Track negative dentries
Message-ID: <20100308132904.GA2936@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil/Joel,

For the small task "Track negative dentries", I have a question that where do
we put the compare of inode lock generations?
During the path walking, I think in only ocfs2_dentry_revalidate() and
ocfs2_lookup() we have the chance to do the compare. For d_revalidate(), we have
to return "not valid" if the dentry is a negative one. So we can only do it in
lookup(). But if d_revalidate() returns "not valid", the dentry will be unhashed
from dentry cache before lookup(). And then for next path walking, the dentry
won't be found in cache and the generation info is also lost(A new dentry object
is created then..).

So how does it work?

regards,
wengang.
