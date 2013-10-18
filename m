From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Oct 2013 13:04:55 -0700
Subject: [Ocfs2-devel] [PATCH 0/6] nocontrold: Eliminating
 ocfs2_controld v4
In-Reply-To: <20131018144449.GA4568@shrek.lan>
References: <20131018144449.GA4568@shrek.lan>
Message-ID: <20131018130455.4b4dc370a7bbc6da235afb82@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 18 Oct 2013 09:44:54 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

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
> 
> For backward compatibility, we are keeping the controld handling code. Once
> enough time has passed we can remove a significant portion of the code.
> 
> This feature requires modification in the userspace ocfs2-tools.
> The changes can be found at:
> https://github.com/goldwynr/ocfs2-tools branch: nocontrold
> Currently, not many checks are present in the userspace code,
> but that would change soon.
> 
> These changes were developed on linux-stable 3.11.y. However, the 
> changes are applicable to the current upstream as well. If you wish
> to give the entire kernel a spin, the link is:
> 
> https://github.com/goldwynr/linux-stable branch: nocontrold

I queued this up so it will get some linux-next exposure when Stephen
gets back to his desk.  But I don't feel I can take it further without
suitable input from the other ocfs2 developers (please).
