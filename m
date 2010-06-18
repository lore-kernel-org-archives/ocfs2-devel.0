From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Jun 2010 18:35:36 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: check dlm_state under spinlock
In-Reply-To: <201006160409.o5G1dABa012133@acsinet15.oracle.com>
References: <201006160409.o5G1dABa012133@acsinet15.oracle.com>
Message-ID: <4C1ACD68.7070006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/15/2010 09:08 PM, Wengang Wang wrote:
> We should check dlm->dlm_state under dlm->spinlock though maybe in this case it
> doesn't hurt.
>    

NAK.

dlm->dlm_state is protected by dlm_domain_lock which is held at that time.

         /* NOTE: Next three are protected by dlm_domain_lock */
         struct kref dlm_refs;
         enum dlm_ctxt_state dlm_state;
         unsigned int num_joins;
