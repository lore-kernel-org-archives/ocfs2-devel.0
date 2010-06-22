From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 22 Jun 2010 11:23:33 +0800
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <4C1F9C74.1060403@oracle.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
	<20100621042716.GA2735@laptop.us.oracle.com>
	<4C1F9C74.1060403@oracle.com>
Message-ID: <20100622032333.GA2403@laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-21 10:08, Sunil Mushran wrote:
> On 06/20/2010 09:27 PM, Wengang Wang wrote:
> >Hi Goldwyn,
> >
> >Has you ever test the hit race?
> >Actually I also wrote the codes locally monthes ago. When I was testing it,
> >I found the dentry are different memory objects. For example, fileA is not
> >exist, we issue a command of 'ls -l /path/to/fileA', At the first run, set
> >parent ino to dentry. At the second run, the parent ino is not there. By
> >printing the address, I found the two dentries are different ones though
> >they are both for "fileA".
> >So I wonder if you tested it.
> >
> 
> I am trying to understand your issue.
> 
> Do you mean you encountered a case in which there were two
> dentries for the same directory entry (/path/to/fileA) but one had
> a correct parent inode and the other had no parent inode.
> 
> Note that a dentry points to a parent dentry that points to the inode.
> So are you claiming that the two dentries pointed to two different parent
> dentries one of which had the correct inode the other null inode?

Actually I meant two dentries in the two run of 'ls -l'.
At the first run, a dentry, dentry A, is created. Because fileA doesn't exist,
dentry->d_inode is NULL. Then a do_revalidate() is run,
ocfs2_dentry_revalidate() returns "not valid" since d_inode is NULL.
Thus the dentry A is unhashed from cache by d_invalidate().
At the second run of 'ls -l', since dentry A is unhashed, there is no dentry for
fileA exist in dentry hash, a new dentry, dentry B, is created. The new dentry B
don't have any info about parent ino.

I found that when testing my patch for the "track negative dentries".
Maybe I misunderstand something?

regards,
wengang.
