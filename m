From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 12 Jul 2010 22:31:55 +0800
Subject: [Ocfs2-devel] [patch] ocfs2: tighten up strlen() checking
In-Reply-To: <20100712132322.GA5658@bicker>
References: <20100710143336.GB19184@bicker>
	<20100712113006.GA2393@laptop.jp.oracle.com>
	<20100712132322.GA5658@bicker>
Message-ID: <20100712143155.GA2625@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Dan,

On 10-07-12 15:39, Dan Carpenter wrote:
> On Mon, Jul 12, 2010 at 07:30:06PM +0800, Wengang Wang wrote:
> > Also, the uuid shouldn't be treated as NULL tailed string.
> > 142 struct ocfs2_control_message_down {
> > 143         char    tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
> > 144         char    space1;
> > 145         char    uuid[OCFS2_TEXT_UUID_LEN];
> > 146         char    space2;
> 
> The space1 and space2 characters are NULL terminators:
> 
> From ocfs2_control_do_down_msg():
>         msg->space1 = msg->space2 = msg->newline = '\0';
> 
> I would have thought it had to be a "packed" struct, but it works
> because there are only chars in that struct.  So that code is fine.

Yes, it is working fine.
I would rather think that structure is misleading than smart :-D.
I prefer this:
	struct ocfs2_control_message_down {
		char    tag[OCFS2_CONTROL_MESSAGE_OP_LEN + 1];
	#define space1 tag[OCFS2_CONTROL_MESSAGE_OP_LEN]
		char    uuid[OCFS2_TEXT_UUID_LEN + 1];
	#define space2 uuid[OCFS2_TEXT_UUID_LEN]
		....

regards,
wengang.
