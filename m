From: jim owens <jowens@hp.com>
Date: Fri, 08 May 2009 08:16:08 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <20090508031018.GB8611@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
Message-ID: <4A042288.6050809@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: joel.becker@oracle.com

Joel Becker wrote:
> On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
>> You certainly did not address:
>>
>> - desire for one single system call to handle both
>>   owner preservation and create with current owner.
> 
> 	Nope, and I don't intend to.  reflink() is a snapshotting call,
> not a kitchen sink.

BTW, the "kitchen sink" argument is bull!

All we are saying is have 1 syscall with 1 vfs operation that
does exactly the same thing except:

if (FLAG_SHAPFILE) {
       if (not CAP_FOWNER)
             return -EPERM
       newfile.attrs = old_file.attrs
) else
       newfile.attrs = user_default_create_attrs

I really think your objection is all because you are
hung up on your reflink() API that has NO EXISTING USERS!

jim
