From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 21 May 2008 10:13:22 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
	groups	lockdep-friendly
In-Reply-To: <20080520215639.GG26609@mail.oracle.com>
References: <20080520163320.025971210@kerlabs.com>
	<20080520095810.1d50d247@infradead.org>
	<20080520215639.GG26609@mail.oracle.com>
Message-ID: <4833D9A2.7020308@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjan van de Ven <arjan@infradead.org>, Joel.Becker@oracle.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Sorry for answering late, it seems that we are working in very different
timezones :)

Joel Becker a ?crit :
> On Tue, May 20, 2008 at 09:58:10AM -0700, Arjan van de Ven wrote:
>> On Tue, 20 May 2008 18:33:20 +0200
>> Louis Rilling <Louis.Rilling@kerlabs.com> wrote:
>>
>>> The following patches fix lockdep warnings resulting from (correct)
>>> recursive locking in configfs.
>>>
>>> ...
>>>
>>> Since lockdep does not handle such correct recursion, the idea is to
>>> insert lockdep_off()/lockdep_on() for inode mutexes as soon as the
>>> level of recursion of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency
>>> pattern increases.
>> I'm... not entirely happy with such a solution ;(
>>
>> there must be a better one.
> 
> 	We're trying to find it.  I really appreciate Louis taking the
> time to approach the issue.  His first pass was to add 1 to MUTEX_CHILD
> for each level of recursion.  This has a very tight limit (4 or 5
> levels), but probably covers all users that exist and perhaps all that
> ever will exist.  However, it means passing the lockdep annotation level
> throughout the entire call chain across multiple files.  It was
> definitely less readable.

The former approach limits the level of recursion, but also the total
number of default groups (whole tree) under a created config_group. I
have use cases for which this limit is too low.

> 	This approach takes a different tack - it's very readable, but
> it assumes that the currently correct locking will always remain so - a
> particular invariant that lockdep exists to verify :-)

Note that I keep lockdep on for the first level of recursion, which lets
lockdep prove that the assumption is correct.

> 	Louis, what about sticking the recursion level on
> configfs_dirent?  That is, you could add sd->s_level and then use it
> when needed.  THis would hopefully avoid having to pass the level as an
> argument to every function.  Then we can go back to your original
> scheme.  If they recurse too much and hit the lockdep limit, just rewind
> everything and return -ELOOP.

I can do this. However, the original approach should be modified since
I_MUTEX_CHILD + 1 == I_MUTEX_XATTR and I_MUTEX_CHILD + 2 ==
I_MUTEX_QUOTA. For instance we could redefine inode_i_mutex_lock_class as

enum inode_i_mutex_lock_class
{
        I_MUTEX_NORMAL,
        I_MUTEX_XATTR,
        I_MUTEX_QUOTA,
        I_MUTEX_PARENT,
        I_MUTEX_CHILD,
};

 ... which lets room for only three levels of recursion, and as many
default groups under any created config_group. Unless we increase
MAX_LOCKDEP_SUBCLASS, I'm afraid that this limit is far too low.

I'll send the patch based on sd->s_level, and we'll see...

Louis

-- 
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/
