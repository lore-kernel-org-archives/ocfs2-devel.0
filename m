From: Andrew Beekhof <beekhof@gmail.com>
Date: Tue, 25 Nov 2008 09:35:11 +0100
Subject: [Ocfs2-devel] [Patch 1/3] ocfs2-tools: Resolve rpmlint warnings
	in init scripts
In-Reply-To: <20081124223046.GE26470@mail.oracle.com>
References: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
	<20081118230312.GB10451@mail.oracle.com>
	<1BC14041-8A8F-40BA-821C-FA838C774CD7@suse.de>
	<20081124221940.GD26470@mail.oracle.com>
	<20081124223046.GE26470@mail.oracle.com>
Message-ID: <26ef5e70811250035p66a34458kf5ebd0b8d77a594f@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 24, 2008 at 23:30, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Mon, Nov 24, 2008 at 02:19:40PM -0800, Joel Becker wrote:
>>       rpmlint is wrong here, as it is tracking a SuSE-only behavior.
>> At least, I can't find a RHEL system that behaves different from LSB.
>
>        Actually, rpmlint is always wrong.  An empty -Stop line is valid
> on sles11 as well - it just means "the same as -Start".

Ok, just ignore the this patch then.
I've no personal attachment to them... its just something that the
SUSE build system threw up and I wanted to be a good OSS citizen by
submitting it upstream :-)

But its seems there's good reason for it to be rejected as distro-specific.

What about the others and the OCF agent?
