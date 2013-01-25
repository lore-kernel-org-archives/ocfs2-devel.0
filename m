From: Bret Towe <magnade@gmail.com>
Date: Fri, 25 Jan 2013 03:40:36 -0000
Subject: [Ocfs2-devel] crash in ocfs2_fast_symlink_readpage in kernel
	3.5.0
In-Reply-To: <20130124143007.39c8545f.akpm@linux-foundation.org>
References: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
	<CALjC5hZwVwRdY6muizzK-+jrq0RH43H6f2kgXstZuco7oM7FyQ@mail.gmail.com>
	<CALjC5hbMq+bc-X8Ad+=gEZLuWy3ZXm4Z0Y2w44k5UZjL4g7vqg@mail.gmail.com>
	<20130124143007.39c8545f.akpm@linux-foundation.org>
Message-ID: <CALjC5hZaVwJBuR17dcM7hG1EMEoAYoUt0S-x6avCxRBuF54RGg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Thu, Jan 24, 2013 at 2:30 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 19 Jan 2013 20:15:33 -0800
> Bret Towe <magnade@gmail.com> wrote:
>
>> >
>> > it looks like you have a patch for this problem in a queue somewhere
>> > (email found on ocfs2-dev:
>> > https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008677.html )
>> > but its not in 3.6, any reason for the delay?
>> > I've been running that patch on 3.5 for a while now likely since
>> > around the time i found that email
>> > and its been working well
>>
>> doesn't look to be in 3.7 or 3.8-git
>> and from what i see on ocfs2-dev there are at least 16 other patches
>> that are also being ignored?
>> I'm sure if I'm bothering at this point to maintain my own patchset to
>> keep ocfs2 from crashing
>> that there is other folks doing the same
>
> Please resend all OCFS2 patches, cc'ing myself, Mark, Joel and
> ocfs2-devel at oss.oracle.com.
>
> I shall then review them, merge them into -mm (and hence linux-next) so
> they can get a bit of visibility and testing while the maintainers are
> checking them over.
>
> Thanks.

I've just been browsing the ocfs2-dev archives do you want me to pull them
and resend or should i just link to the archive?
keep in mind I'm just a end user not really a dev persay
if you do want me to send the patches however I assume there is a document
i should read first?
