From: Lars Marowsky-Bree <lmb@suse.de>
Date: Fri Oct 28 10:11:19 2005
Subject: [Ocfs2-devel] Re: [RFC] Integration with external clustering
In-Reply-To: <43556F8B.3060105@suse.com>
References: <43556F8B.3060105@suse.com>
Message-ID: <20051028151057.GQ24595@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-18T17:56:27, Jeff Mahoney <jeffm@suse.com> wrote:

Hi all,

just want to make sure this doesn't get lost. Where are we currently
at?

FYI, I'd like to ask for an additional way of documenting a suggested
approach: Please show how to setup a, say, 3 node "cluster" (statically)
and how to shut it down again - on the commandline with shell scripts
;-) Hey, we're only operating on configfs/sysfs style "text files" and
directories, no? That should be possible.

Not only will it be a good basis for a regression test of the API, but
it'll also help us understand how the scripts for the Cluster Resource
Manager integration will have to look like and whether that's a
workable approach.

Anybody thinking I'm on drugs? ;-)


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
