From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 21 Jun 2010 22:38:43 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <20100622052248.GA2362@laptop.us.oracle.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
	<20100621042716.GA2735@laptop.us.oracle.com>
	<4C1F9C74.1060403@oracle.com>
	<20100622032333.GA2403@laptop.cn.oracle.com>
	<20100622033624.GB15659@mail.oracle.com>
	<20100622052248.GA2362@laptop.us.oracle.com>
Message-ID: <94FE29C8-AA07-4B63-99A3-AB8AEF660AC8@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Are you referring to the dentry lock? We encode the parent inode in  
the lock. But the difference is that a dentry having that lock cannot  
be a negative dentry.

On Jun 21, 2010, at 10:22 PM, Wengang Wang <wen.gang.wang@oracle.com>  
wrote:

> On 10-06-21 20:36, Joel Becker wrote:
>> On Tue, Jun 22, 2010 at 11:23:33AM +0800, Wengang Wang wrote:
>>> Actually I meant two dentries in the two run of 'ls -l'.
>>> At the first run, a dentry, dentry A, is created. Because fileA  
>>> doesn't exist,
>>> dentry->d_inode is NULL. Then a do_revalidate() is run,
>>> ocfs2_dentry_revalidate() returns "not valid" since d_inode is NULL.
>>> Thus the dentry A is unhashed from cache by d_invalidate().
>>> At the second run of 'ls -l', since dentry A is unhashed, there is  
>>> no dentry for
>>> fileA exist in dentry hash, a new dentry, dentry B, is created.  
>>> The new dentry B
>>> don't have any info about parent ino.
>>>
>>> I found that when testing my patch for the "track negative  
>>> dentries".
>>> Maybe I misunderstand something?
>>
>>    When that dentry gets linked into the tree, it will point to its
>> d_parent.  So the parent inode is dentryB->d_parent->d_inode.
>
> Yes Joel, I know that link.
> I meant there is no parent inode number stored on on dentryB it's  
> self,
> thus no way to compare it with dentryB->d_parent->d_inode.
> We set the parent inode number info to dentryA(somewhere in d_fsdata).
> But it's lost at the second 'ls -l' because dentryB is got instead  
> of dentryA.
>
> regards,
> wengang.
