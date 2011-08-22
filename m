From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sun, 21 Aug 2011 22:45:46 -0700
Subject: [Ocfs2-devel] ocfs2 cleanups,
 bug fixes for Linux kernel 3.1 - final drop
In-Reply-To: <20110822042330.GC31134@noexit.corp.google.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
	<20110822042330.GC31134@noexit.corp.google.com>
Message-ID: <4E51ED0A.1080907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/21/2011 09:23 PM, Joel Becker wrote:
> On Thu, Jul 14, 2011 at 03:50:11PM -0700, Sunil Mushran wrote:
>> Joel,
>>
>> Hopefully this is the final drop before the 3.1 merge window. I had posted most
>> of the patches before. In fact the first 12 are exactly the same. The 13th one
>> is modified and 14,15,16 are new.
> Hey Sunil,
> 	These changes are now in the 'fixes' branch of ocfs2.git.  Sorry
> this took so long.  I plan to send the SEEK_HOLE patch along, and if
> Linus wants it out I will take it out.
> 	My only comment on the series, which is otherwise quite nicely
> put together, is that new mlog()s should be replaced by trace events.
> I'm going to let them in for this time, but please consider updating
> them in another patch.

I don't think I added new mlogs. I removed some and replaced
some with printks. The goal is to replace all with trace events.
