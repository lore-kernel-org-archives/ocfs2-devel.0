From: Germano Percossi <germano.percossi@citrix.com>
Date: Mon, 15 Dec 2014 18:47:02 +0000
Subject: [Ocfs2-devel] ocfs2-tools repository and documentation
In-Reply-To: <548D3B1E.5030309@suse.de>
References: <54874E4C.8040006@citrix.com> <548D3B1E.5030309@suse.de>
Message-ID: <548F2CA6.4060707@citrix.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,

Thanks for your answer. I will have a look at your code.
I just want to be sure that the source code I am looking at
is the latest one to avoid fixing things that maybe have been already
fixed elsewhere.

Same is true for documentation and package repositories.
If I could have links to the latest, no matter how old and not
maintained, documentation and repository, it would be helpful,
as well.

Do you know of any other distro, besides Suse, maintaining a stack
of patches?

Cheers,
Germano

On 14/12/14 07:24, Goldwyn Rodrigues wrote:
>
> Yes, if you don't count the last 2 patches, it is more close to 3 years
> now ;)
>
> Since the patches were not being updated. I started maintaining an
> alternate repository where I am putting all the bugs reported at SUSE:
>
> https://github.com/goldwynr/ocfs2-tools
>
> Branch suse-fixes has the fixes found by SUSE over the "upstream" branch.
>
> Branch nocontrold has the patches for the feature of doing away with
> ocfs2_controld to work with the latest corosync/pacemaker stack. Patches
> for the kernel are already in the kernel but the ones in the tools need
> some review.
>
> I had a mail conversation with Srini and he has promised to update the
> upstream branch soon.
>
> Regards,
>
