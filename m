From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 6 Sep 2013 12:40:57 -0700
Subject: [Ocfs2-devel] [PATCH 0/6] nocontrold: Eliminating ocfs2_controld
In-Reply-To: <20130906032651.GA4148@shrek.lan>
References: <20130906032651.GA4148@shrek.lan>
Message-ID: <20130906194057.GB31381@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Firstly, thanks for developing this Goldwyn. I've been looking at the
patches, and plan to review the series (in kernel) for you.

Quick question - do you have a pointer handy to the development stream on
the dlm / gfs side of things? It would be instructive to see how it was done
in more than one place.
	--Mark

On Thu, Sep 05, 2013 at 10:26:56PM -0500, Goldwyn Rodrigues wrote:
> Hi,
> 
> I am re-sending this patch series because I did not get a response
> for the previous set.
> 
> This is an effort of removing ocfs2_controld.pcmk and getting ocfs2 DLM
> handling up to the times with respect to DLM (>=4.0.1) and corosync
> (2.3.x). AFAIK, cman also is being phased out for a unified corosync
> cluster stack.
> 
> fs/dlm performs all the functions with respect to fencing and node
> management and provides the API's to do so for ocfs2. For all future
> references, DLM stands for fs/dlm code.
> 
> The advantages are:
>  + No need to run an additional userspace daemon (ocfs2_controld)
>  + No contrrold devince handling and controld protocol
>  + Shifting responsibilities of node management to DLM layer
>  + Huge reduction in source code, both in kernel and userspace
> 
> This feature requires modification in the userspace ocfs2-tools.
> The changes can be found at:
> https://github.com/goldwynr/ocfs2-tools branch: nocontrold
> Currently, not many checks are present in the userspace code,
> but that would change soon.
> 
> These changes were developed on linux-stable 3.10.y, though they 
> are applicable at the current upstream as well. If you want to give
> the entire kernel a spin, the link is:
> 
> https://github.com/goldwynr/linux-stable branch: nocontrold
> 
> Review comments/suggestions/criticism welcome.
> 
> -- 
> Goldwyn
--
Mark Fasheh
