From: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed Jul 20 13:09:23 2005
Subject: [Clusters_sig] RE: [Linux-cluster] Re: [Ocfs2-devel] [RFC]
	nodemanager, ocfs2, dlm
In-Reply-To: <3689AF909D816446BA505D21F1461AE404167CFB@cacexc04.americas.cpqcorp.net>
References: <3689AF909D816446BA505D21F1461AE404167CFB@cacexc04.americas.cpqcorp.net>
Message-ID: <20050720180918.GU5416@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Walker, Bruce J (HP-Labs)" <bruce.walker@hp.com>, linux clustering <linux-cluster@redhat.com>, David Teigland <teigland@redhat.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, clusters_sig@lists.osdl.org

On 2005-07-20T09:55:31, "Walker, Bruce J (HP-Labs)" <bruce.walker@hp.com> wrote:

> Like Lars, I too was under the wrong impression about this configfs
> "nodemanager" kernel component.  Our discussions in the cluster
> meeting Monday and Tuesday were assuming it was a general service that
> other kernel components could/would utilize and possibly also
> something that could send uevents to non-kernel components wanting a
> std. way to see membership information/events.

Let me clarify that this was something we briefly touched on in
Walldorf: The node manager would (re-)export the current data via sysfs
(which would result in uevents being sent, too), and not something we
dreamed up just Monday ;-)

> As to kernel components without corresponding user-level "managers",
> look no farther than OpenSSI.  Our hope was that we could adapt to a
> user-land membership service and this interface thru configfs would
> drive all our kernel subsystems.

Well, node manager still can provide you the input as to which nodes are
configured, which in a way translates to "membership". The thing it
doesn't seem to provide yet is the supsend/modify/resume cycle which for
example the RHAT DLM seems to require.


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
