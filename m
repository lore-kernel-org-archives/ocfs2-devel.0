From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 23 Jun 2010 13:30:18 -0500
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <20100621042716.GA2735@laptop.us.oracle.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
	<20100621042716.GA2735@laptop.us.oracle.com>
Message-ID: <AANLkTinY9qxRVE_TpVfdYASv_i-D8MJCZFilIxT0St8p@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Jun 20, 2010 at 11:27 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> Hi Goldwyn,
>
> Has you ever test the hit race?

Yes, I tested it before posting.

> Actually I also wrote the codes locally monthes ago. When I was testing it,
> I found the dentry are different memory objects. For example, fileA is not
> exist, we issue a command of 'ls -l /path/to/fileA', At the first run, set
> parent ino to dentry. At the second run, the parent ino is not there. By
> printing the address, I found the two dentries are different ones though
> they are both for "fileA".

What you might be hitting is reuse of negative dentries. IOW,
conversion of negative dentries into positve dentries. I have handled
that. I did not printk pointers but did print generation numbers and
they looked fine. However, I did not encounter a case with a negative
dentry with a misplaced or a null d_parent.

-- 
Goldwyn
