From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 3 Oct 2013 13:30:52 -0700
Subject: [Ocfs2-devel] [PATCH 0/5] nocontrold: Eliminating
 ocfs2_controld v3
In-Reply-To: <20131003054851.GA12878@shrek.lan>
References: <20131003054851.GA12878@shrek.lan>
Message-ID: <20131003133052.7b463a37474754fac991a8fa@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 3 Oct 2013 00:48:55 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

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
> These changes were developed on linux-stable 3.11.y, though they 
> are applicable at the current upstream as well. If you want to give
> the entire kernel a spin, the link is:
> 
> https://github.com/goldwynr/linux-stable branch: nocontrold
> 
> Changes since v2:
> * Joel's comments: patch re-factoring
> * No need to safeguard cluster_stack
> 
> Changes since v1:
> * Backward compatibility with ocfs2_controld
> * Moved cluster_stack change restriction to dlm code

I'm not really sure what to do with this patchset.  It's too deep for
me to merge on my own cognizance so I am dependent upon reviews and
acks from ocfs2 specialists before I can move forward.  Where are we at
with that?
