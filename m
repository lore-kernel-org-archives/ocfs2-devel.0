From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 26 Jan 2010 04:33:26 -0800
Subject: [Ocfs2-devel] dlmglue fixes
In-Reply-To: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
References: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100126123325.GB3845@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 21, 2010 at 10:50:01AM -0800, Sunil Mushran wrote:
> So here are the two patches. Remove all patches that you have and apply
> these.
> 
> The first one is straight forward.
> 
> The second one will hopefully fix the livelock issue you have been
> encountering.
> 
> People reviewing the patches should note that the second one is slightly
> different than the one I posted earlier. It removes the BUG_ON in the if
> condition where we jump to update_holders. The accompanying comment has
> also been updated.

David,
	Don't know if you saw this, so I'm adding you to the CC.
Hopefully you can test it out; let us know if there are further
problems!

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
