From: jim owens <jowens@hp.com>
Date: Mon, 11 May 2009 18:49:01 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <20090511204924.GC30293@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090511204924.GC30293@mail.oracle.com>
Message-ID: <4A08AB5D.7090706@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joel.becker@oracle.com, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org

Joel Becker wrote:
> On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
>> - fix the
>> +	if (S_ISDIR(inode->i_mode))
>> +		return -EPERM;
>>
>>   to be an ISREG check unless you have an argument for
>>   special files and symlinks being COWed.
> 
> 	I'm unsure on this one, and would like other comments.  Why?  It
> doesn't *hurt* to allow reflink on symlinks or special files.  Mostly
> it's a waste - symlinks may have a data extent, but special files do
> not.  But I'm not sure there's a point to arbitrarily limit filesystems
> when there's nothing we're combating.
> 	Jim, if you have a real problem this prevents, I'm all ears.
> And if others concur that restricting it to regular files is the right
> way to go, I can be convinced.

My only problem was my past experience on non-Linux systems
where once we said it works for multiple file types, we had
to support that forever across all filesystems.  We could add
support for more types but not eliminate supported ones.

Since only ocfs2 will initially support this, I'm fine with the
S_ISDIR and if in the future other filesystems can only support
regular files (or can also support directories), we move the
check out of VFS to be filesystem specific.

jim
