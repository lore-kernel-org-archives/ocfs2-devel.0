From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 May 2009 16:42:49 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <4A08B084.3070209@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com> <4A08B084.3070209@hp.com>
Message-ID: <20090511234249.GB28209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Mon, May 11, 2009 at 07:11:00PM -0400, jim owens wrote:
> Joel Becker wrote:
>> 	Here's v4 of reflink().  If you have the privileges, you get the
>> full snapshot.  If you don't, you must have read access, and then you
>> get the entire snapshot (data and extended attributes) except that the
>> security context is reinitialized.  That's it.  It fits with most of the
>> other ops, and it's a clean degradation.
>
> I really like this.  It has a nice clean user operational definition
> and gives them all the snap/cowfile features.  And if they had the
> privilege to do the reflink(), they can just chattr away :)
>
> jim
>
>> +	/*
>> +	 * If the caller has the rights, reflink() will preserve the
>> +	 * security context of the source inode.
>> +	 */
>> +	if ((current_fsuid() != inode->i_uid) && !capable(CAP_CHOWN))
>> +		preserve_security = 0;
>> +	if ((current_fsuid() != inode->i_uid) &&
>> +	    !in_group_p(inode->i_gid) && !capable(CAP_CHOWN))
>> +		preserve_security = 0;
>
> I have not done a code review, but that appears to be an
> editing cut-and-past duplication.

	Oh, good catch.

Joel

-- 

"In the long run...we'll all be dead."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
