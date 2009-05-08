From: jim owens <jowens@hp.com>
Date: Fri, 08 May 2009 10:11:57 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <4A042288.6050809@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com> <4A042288.6050809@hp.com>
Message-ID: <4A043DAD.9040806@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, joel.becker@oracle.com

> Joel Becker wrote:
>> On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
>>> You certainly did not address:
>>>
>>> - desire for one single system call to handle both
>>>   owner preservation and create with current owner.
>>
>>     Nope, and I don't intend to.  reflink() is a snapshotting call,

You might have designed this for *snapshotting*
but from a user perspective the function is best described as:

*Copy_file_attributes() and Cow_file_data()*

Since immediately afterwards the reflink() you permit everything
to be modified on the new file.

Your design is good, but you need to admit to yourself
that the Copy_file_attributes() is the special case
as far as users are concerned.  Because most people expect
snapshots are immutable and these are really files that
don't use up space and can be used as snapshots
*if you don't modify them*.

jim
