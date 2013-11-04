From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 4 Nov 2013 14:09:36 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] Add DLM recovery callbacks
In-Reply-To: <52771845.2040808@suse.de>
References: <20131018144520.GA4579@shrek.lan>
	<20131103221644.GH29346@wotan.suse.de> <52771845.2040808@suse.de>
Message-ID: <20131104220936.GP29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Nov 03, 2013 at 09:45:09PM -0600, Goldwyn Rodrigues wrote:
> On 11/03/2013 04:16 PM, Mark Fasheh wrote:
> > This also looks good in that I don't see anything wrong with the way the
> > actual code functions. The extra description you put about the callbacks
> > helps in understanding this too. Question - can you explain why oc_this_node
> > is an atomic? That is to say I'd like to understand that race that you're
> > protecting against :)
> > 	--Mark
> 
> Ok, we may not require this to be atomic. The dlm thread sets up 
> oc_this_node via .recover_done(), but it should not matter because 
> this_node() functions are called after .cluster_connect().

Ahh alright. And this is probably a silly question, but we know the dlm will
never call this code concurently?
	--Mark

--
Mark Fasheh
