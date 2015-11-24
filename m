From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 24 Nov 2015 13:46:17 -0800
Subject: [Ocfs2-devel] [PATCH v2 2/4] ocfs2: sysfile interfaces for
	online file check
In-Reply-To: <56386E4B.5080506@oracle.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<1446013561-22121-3-git-send-email-ghe@suse.com>
	<5638604E.9030000@oracle.com>
	<5638D8CF020000F90001CC68@relay2.provo.novell.com>
	<56386E4B.5080506@oracle.com>
Message-ID: <20151124214617.GT15575@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Gang He <ghe@suse.com>, rgoldwyn@suse.de, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Nov 03, 2015 at 04:20:27PM +0800, Junxiao Bi wrote:
> Hi Gang,
> 
> On 11/03/2015 03:54 PM, Gang He wrote:
> > Hi Junxiao,
> > 
> > Thank for your reviewing.
> > Current design, we use a sysfile as a interface to check/fix a file (via pass a ino number).
> > But, this operation is manually triggered by user, instead of automatically  fix in the kernel.
> > Why?
> > 1) we should let users make this decision, since some users do not want to fix when encountering a file system corruption, maybe they want to keep the file system unchanged for a further investigation.
> If user don't want this, they should not use error=continue option, let
> fs go after a corruption is very dangerous.

Maybe we need another errors=XXX flag (maybe errors=fix)?

You both make good points, here's what I gather from the conversation:

 - Some customers would be sad if they have to manually fix corruptions.
   This takes effort on their part, and if the FS can handle it
   automatically, it should.

 - There are valid concerns that automatically fixing things is a change in
   behavior that might not be welcome, or worse might lead to unforseeable
   circumstances.

 - I will add that fixing things automatically implies checking them
   automatically which could introduce some performance impact depending on
   how much checking we're doing.

So if the user wants errors to be fixed automatically, they could mount with
errros=fix, and everyone else would have no change in behavior unless they
wanted to make use of the new feature.


> > 2) frankly speaking, this feature will probably bring a second corruption if there is some error in the code, I do not suggest to use automatically fix by default in the first version.
> I think if this feature could bring more corruption, then this should be
> fixed first.

Btw, I am pretty sure that Gang is referring to the feature being new and
thus more likely to have problems. There is nothing I see in here that is
file system corrupting.
	--Mark


--
Mark Fasheh
