From: jim owens <jowens@hp.com>
Date: Fri, 08 May 2009 07:53:21 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <20090508031018.GB8611@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
Message-ID: <4A041D31.1030009@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

Joel Becker wrote:
> On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
>> You certainly did not address:
>>
>> - desire for one single system call to handle both
>>   owner preservation and create with current owner.
> 
> 	Nope, and I don't intend to.  reflink() is a snapshotting call,
> not a kitchen sink.

I'm not a maintainer but if I was, in that case I would
NAK this since more people wanted the cowfile() definition
than your reflink definition.

If you persist that you are only doing the snapshot
then call it snaplink(2) or something.

The reflink() name makes no sense because all references are
internal to the file system.  There is absolutely no way via
"ls" to determine the reference between the original and new.

With hard links and symlinks you can easily associate them.

jim
