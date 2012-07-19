From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Thu, 19 Jul 2012 11:29:26 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: break useless while loop
In-Reply-To: <20120711085120.GE30630@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1341989396-19598-1-git-send-email-junxiao.bi@oracle.com>
	<20120711085120.GE30630@dhcp-172-17-9-228.mtv.corp.google.com>
Message-ID: <CAEeiSHVwW+smeRv8Vr7CdWRnSJA4uKN=CyxawQFOHgJqBU4dGQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 11, 2012 at 1:51 AM, Joel Becker <jlbec@evilplan.org> wrote:

> On Wed, Jul 11, 2012 at 02:49:56PM +0800, Junxiao Bi wrote:
> > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> > ---
> >  fs/ocfs2/dlm/dlmmaster.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> > index 005261c..1fadc39 100644
> > --- a/fs/ocfs2/dlm/dlmmaster.c
> > +++ b/fs/ocfs2/dlm/dlmmaster.c
> > @@ -1888,8 +1888,10 @@ ok:
> >                        * up nodes that this node contacted */
> >                       while ((nn = find_next_bit (mle->response_map,
> O2NM_MAX_NODES,
> >                                                   nn+1)) <
> O2NM_MAX_NODES) {
> > -                             if (nn != dlm->node_num && nn !=
> assert->node_idx)
> > +                             if (nn != dlm->node_num && nn !=
> assert->node_idx) {
> >                                       master_request = 1;
> > +                                     break;
> > +                             }
>
>         Seems like this will save a tiny bit of CPU in the assert master
> handler.  Sunil, can you see any problem?
>
>
Looks good to me. ACK.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120719/01a7dfb2/attachment.html 
