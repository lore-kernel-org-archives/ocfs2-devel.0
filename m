From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue, 02 May 2006 13:29:11 -0700
Subject: [Ocfs2-devel] OCFS2 Features RFC
In-Reply-To: <1146594129.4149.74.camel@brilong-lnx>
References: <1146594129.4149.74.camel@brilong-lnx>
Message-ID: <4457C117.5000200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Brian Long wrote:
> Is there any reason you wouldn't ask the ocfs2-users community for
> feedback on features as well?  I hadn't subscribed to -devel because I
> figured it was solely for folks actually developing the OCFS2 code  :)
>   
-devel is for all discussion regarding ocfs2 development. It is not limited
to developers. We could have posted this to -users too, but I guess one is
trying not to cross the "spam" line.

> In my opinion, the proposed feature about "hard read only" is the most-
> wanted.  My team is in the middle of testing 10gR2 RAC on OCFS2 for
> production deployments on RHEL 4 (hopefully your x86_64 certification is
> coming soon).  I assume Oracle RAC would like the "hard read only" more
> than the current panic.
>
> Also, while I saw one end user complain about your ideas of implementing
> ext3 code inside OCFS2, please remember the rest of us that survive just
> fine with ext3 in Red Hat's Enterprise Linux.  :)
>   
:)

> Third, is there any thoughts on integrating LVM support or using
> something like Red Hat's CLVM to allow OCFS2 to layer on top of LVs
> instead of just individual disks?
>
> The biggest drawback I see in my environment is that my storage team
> provides 34GB and 68GB metas from the EMC Frames.  I'd rather not have a
> ton of 68GB OCFS2 filesystems but rather a larger, host-controlled LV.
> Trying to get the storage team to provide a 200+GB LUN and grow it on
> the fly in the future is a tough task.  If I could control the LV on the
> host _and_ grow OCFS2 into larger LVs, that would rock.
>   
We are looking into this.
