From: Lars Marowsky-Bree <lmb@suse.com>
Date: Fri, 06 Sep 2013 11:27:12 -0000
Subject: [Ocfs2-devel] [PATCH 0/6] nocontrold: Eliminating ocfs2_controld
In-Reply-To: <20130906032651.GA4148@shrek.lan>
References: <20130906032651.GA4148@shrek.lan>
Message-ID: <20130906112253.GQ1553@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013-09-05T22:26:56, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

Hi Goldwyn,

thanks! This looks really good.

> This is an effort of removing ocfs2_controld.pcmk and getting ocfs2 DLM
> handling up to the times with respect to DLM (>=4.0.1) and corosync
> (2.3.x). AFAIK, cman also is being phased out for a unified corosync
> cluster stack.

That's clearly necessary, also to bring OCFS2 more uptodate with the
latest happenings in the GFS2 world; it'll allow both file systems to
share exactly the same cluster stack.

> https://github.com/goldwynr/ocfs2-tools branch: nocontrold
> Currently, not many checks are present in the userspace code,
> but that would change soon.

There's one question I have; how will this handle

- the "old" user-space code starting on a new kernel,
- or the "new" user-space code being run on an old kernel?

Is there anything we can do to at least provide a meaningful error
message in the first case? The second should be easier to handle.


Regards,
    Lars

-- 
Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend?rffer, HRB 21284 (AG N?rnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
