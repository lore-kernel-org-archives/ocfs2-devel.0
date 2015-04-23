From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Fri, 24 Apr 2015 01:37:34 +0200
Subject: [Ocfs2-devel] [PATCH next] ocfs2: Reduce object size of mlog
	uses
In-Reply-To: <20150423161923.be61ea8cd9e64a9e30a23eca@linux-foundation.org>
References: <1429255070.2850.84.camel@perches.com>
	<20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
	<20150423230418.GR17170@wotan.suse.de>
	<20150423161923.be61ea8cd9e64a9e30a23eca@linux-foundation.org>
Message-ID: <CAFLxGvzt2V=vVV3u7ur19wDMhmnqri5ctaqbxpo_fW1bohqzUA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.de>, Joe Perches <joe@perches.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Fri, Apr 24, 2015 at 1:19 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 23 Apr 2015 16:04:18 -0700 Mark Fasheh <mfasheh@suse.de> wrote:
>
>> > This code needs some pretty serious rework and rethink, perhaps
>> > involving a change to the emitted info.  I was hoping one of the ocfs2
>> > developers would take the bait, but they're all in hiding.
>>
>> If it functions the same and doesn't have a major performance change, I'm
>> pretty sure it'll be fine. We sometimes ask customers to enable some of the
>> debugging if they are having an issue. I would ask that it be tested
>> on a live system - a local fs, no cluster or cluster config required.
>
> Is there a simpleton's guide to testing ocfs2 on a local disk?  One
> which assumes a starting point of "knows how to type".

See http://docs.oracle.com/cd/E37670_01/E41138/html/ol_crlcl_ocfs2.html

-- 
Thanks,
//richard
