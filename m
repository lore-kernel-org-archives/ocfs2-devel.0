From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 May 2009 16:46:24 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <4A08AB5D.7090706@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090511204924.GC30293@mail.oracle.com> <4A08AB5D.7090706@hp.com>
Message-ID: <20090511234624.GC28209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org

On Mon, May 11, 2009 at 06:49:01PM -0400, jim owens wrote:
> Joel Becker wrote:
>> On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
>>> - fix the
>>> +	if (S_ISDIR(inode->i_mode))
>>> +		return -EPERM;
>>>
>>>   to be an ISREG check unless you have an argument for
>>>   special files and symlinks being COWed.
>>
>> 	Jim, if you have a real problem this prevents, I'm all ears.
>> And if others concur that restricting it to regular files is the right
>> way to go, I can be convinced.
>
> My only problem was my past experience on non-Linux systems
> where once we said it works for multiple file types, we had
> to support that forever across all filesystems.  We could add
> support for more types but not eliminate supported ones.

	Someone else pointed out that a naive user might reflink a block
device file and expect the device contents to be copied-on-write.
Obviously wrong if you understand filesystems, but let's just prevent
that misunderstanding.  S_ISREG() it is.

Joel

-- 

"All alone at the end of the evening
 When the bright lights have faded to blue.
 I was thinking about a woman who had loved me
 And I never knew"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
