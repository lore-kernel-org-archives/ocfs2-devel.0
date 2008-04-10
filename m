From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Thu, 10 Apr 2008 16:24:06 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add cluster lock stats at the
 fs level
In-Reply-To: <20080410231504.GC21261@wotan.suse.de>
References: <1207178188-30130-1-git-send-email-sunil.mushran@oracle.com>
	<20080410220019.GZ21261@wotan.suse.de>
	<47FE9B1F.1080201@oracle.com>
	<20080410231504.GC21261@wotan.suse.de>
Message-ID: <47FEA196.2060804@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

struct ocfs2_alloc_stats alloc_stats;

Though this is off osb so has a smaller memory footprint.

Mark Fasheh wrote:
> On Thu, Apr 10, 2008 at 03:56:31PM -0700, Sunil Mushran wrote:
>   
>> How about I add another config OCFS2_ENABLE_STATS? OCFS2_DEBUG_FS
>> is truly debugging that has no place in a prod env while this is
>> could potentially be very useful in the same env.
>>     
>
> Sure. The Kconfig text can mention that the tradeoff is larger structure
> sizes, etc. Out of curiousity, can you think of any other bits we can put
> behind it in our first pass?
> 	--Mark
>
> --
> Mark Fasheh
>   
