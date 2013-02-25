From: Jeff Liu <jeff.liu@oracle.com>
Date: Mon, 25 Feb 2013 22:19:06 +0800
Subject: [Ocfs2-devel] [RFC PATCH 0/3] copy-on-write extents mapping
In-Reply-To: <20130225132844.GB8232@quack.suse.cz>
References: <51244A15.2060508@oracle.com>
	<20130221152520.GA17067@quack.suse.cz>
	<20130221180039.GX22221@lenny.home.zabbo.net>
	<512A18C6.6090601@oracle.com> <20130225132844.GB8232@quack.suse.cz>
Message-ID: <512B72DA.4010205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: zab@zabbo.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

On 02/25/2013 09:28 PM, Jan Kara wrote:
>   Hi Jeff,
> 
> On Sun 24-02-13 21:42:30, Jeff Liu wrote:
>> Thanks for both of your comments and sorry for my too late response since
>> I have to think it over and run tests to gather the performance
>> statistics.
>   Sure, no problem.
> 
>>
>> No matter kernel is patched or not, there basically no performance
>> improvements although 12 times fiemap ioctl(2) are reduced
> <snip>
>   Yeah, I suspected that. As Zach said, kernel has to do all the work
> anyway so you just save some small overhead of additional syscalls. But
> those are rather cheap compared to other stuff you need to do.
> 
>> But I have another idea regarding the performance if considering the
>> practical situations.  Generally, the end user would run du(1) against a
>> partition with not only the reflinked files but also includes normal
>> files which are not contains any shared extents, or if the user check up
>> the shared extents for a previous reflinked file, but maybe this file has
>> already totally COWed, that is, now it does not contains any shared
>> extent at all.
>>
>> In either case, du(1) has to call fiemap to look through the extents
>> against this kind of files no matter it contains shared extents or not,
>> that's would be an overhead(Yes, du(1) is not a very performance critical
>> application).
>>
>> But with a prejudegement approach, we can bypass the normal files and
>> lookup shared extents against the COW file only.
>   Yes, that would be useful and as you showed it can bring noticeable
> speedup.
> 
>> Does the results above looks make sense?  If yes, I still felt that it's
>> not a formal approach to detect reflinked files.  IMHO, if we can improve
>> the stat(2)->getattr() to fill the mode member with a flag to indicate
>> that a file is reflinked/cow or not, it would be more convenient to check
>> as like S_ISREFLINK(stat.st_mode) from the user space since du(1) always
>> fetching the statistics per file disk space accounting.
>   I agree that adding filtering to FIEMAP just to accomodate the only
> practical use case of checking whether a file has any shared extent is
> really an overkill. But changing stat(2) the way you describe is ugly hack.
> st_mode has logically nothing to do with whether file has shared extents or
> not. If anything you could use ioctl IOC_GETFLAGS for that. I'm not 100%
> sure that's the right interface but at least it isn't that ugly.
Hi Jan,

Thanks for your quick response and thanks for pointing me out, I have
not realized this interface before, looks it's very nice in this
situation, I'll try it out. :)

Regards,
-Jeff
