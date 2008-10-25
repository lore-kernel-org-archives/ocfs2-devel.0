From: Mark Fasheh <mfasheh@suse.com>
Date: Sat, 25 Oct 2008 14:19:00 -0700
Subject: [Ocfs2-devel] xattr fixes branch
In-Reply-To: <20081024002246.GF12751@mail.oracle.com>
References: <20081024002246.GF12751@mail.oracle.com>
Message-ID: <20081025211900.GP15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 23, 2008 at 05:22:46PM -0700, Joel Becker wrote:
> Folks,
> 	To keep track of what we want to upstream in the 2.6.28-rc
> cycle, I've put together a branch called 'xattr-28' with almost all of
> the patches merged.  You can see it and pull it from my linux-2.6.git
> repository.

Joel,

	Thanks for doing this. I've got the patches all pulled into
ocfs2.git now, and they're ready to go. I'm thinking we should try something
new this time around. I'd like to get yours and everyone elses opinions on
this.

	I'm thinking to keep fixes that will go upstream in the current
release in a 'fixes' branch. For 2.6.28, I started this from your xattr-28
branch, put my signoffs on the patches, and added an mmap fix from Tao which
I had already. This will get rebased every time I send fixes upstream.

	For new features, I started a merge_window branch. This worked
really well for us recently imho. Early in the cycle, this might get rebased
as large-ish fixes are pushed upstream. By the end of the development cycle
though (when fixes are smaller), I suspect it won't have to be rebased as
often, or at all.

	If people wouldn't mind developing against some version of
merge_window, it would make getting all this stuff together much easier. As
always though, if the choice is between rebasing or doing some PITA merge
versus getting a high quality feature going, feel free to push the merge
pain onto me :)

	Right now, merge_window is based on upstream. I'm thinking perhaps
we should base it on the current 'fixes' branch, since some of them are on
the large-ish side - that would make getting our patches together more
smoothly.

	'linux-next' and 'ALL' branches would stay the same - a merge of
everything we've got, intended to go into the linux-next and -mm trees.


	Tiger - you had asked me to keep the previous merge_window branch
around. It's now in ocfs2.git as 'merge_window_28'. Let me know if I can
remove this.
	--Mark

--
Mark Fasheh
