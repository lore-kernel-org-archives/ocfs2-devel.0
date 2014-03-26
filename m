From: Sasha Levin <sasha.levin@oracle.com>
Date: Wed, 26 Mar 2014 18:23:41 -0400
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if cluster name exists
	before deref
In-Reply-To: <20140326220018.GE5716@wotan.suse.de>
References: <1395768118-21368-1-git-send-email-sasha.levin@oracle.com>
	<20140326220018.GE5716@wotan.suse.de>
Message-ID: <5333536D.5020603@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/26/2014 06:00 PM, Mark Fasheh wrote:
> On Tue, Mar 25, 2014 at 01:21:58PM -0400, Sasha Levin wrote:
>> As a side note, how the hell was this new code path tested?
>> It's obviously broken and there's no way it even passes
>> a very basic test.
>
> I'm not trying to 'defend' Goldwyn, or anything, but mistakes get made -
> it's a fact of life. We have a review process to hopefully catch these sorts
> of things, you are welcome to take part in it. In fact, if you were
> willing to test and report these sorts of things to the Ocfs2-devel list
> before they go upstream that would probably help prevent this sort of thing
> from happening in the future.

Hi Mark,

I'm fuzz testing the kernel and not really testing or reviewing any subsystem
in particular.

My frustration about not testing it was because it's so simple to reproduce this
issue:

  # mount -t ocfs2_dlmfs ocfs2_dlmfs dlm
  # mkdir dlm/anything
  [ boom ]

This is a very basic test that should have been run more than once before this
patch made it into Linus's tree. Whether as part of some ocfs2 test suite or
maybe xfstest.

My beef is not with Goldwyn not testing that path, it's more with whatever
process (or lack thereof) ocfs2 has to test and verify patches before
they make it upstream. Even if Goldwyn missed it, it should have been
caught at a different place on it's way.


Thanks,
Sasha
