From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 4 Nov 2013 14:12:39 -0800
Subject: [Ocfs2-devel] [PATCH 5/6] Framework for version LVB
In-Reply-To: <527718A7.1010706@suse.de>
References: <20131018144608.GA4594@shrek.lan>
	<20131104011000.GM29346@wotan.suse.de> <527718A7.1010706@suse.de>
Message-ID: <20131104221239.GR29346@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Nov 03, 2013 at 09:46:47PM -0600, Goldwyn Rodrigues wrote:
> On 11/03/2013 07:10 PM, Mark Fasheh wrote:
>> On Fri, Oct 18, 2013 at 09:46:12AM -0500, Goldwyn Rodrigues wrote:
>>> +static void version_to_lvb(struct ocfs2_protocol_version *ver, char *lvb)
>>> +{
>>> +	memcpy(lvb, ver, sizeof(struct ocfs2_protocol_version));
>>> +}
>>
>> You'll need to account for mixed-endian clusters here and above. Look at
>> ocfs_stuff_meta_lvb() and ocfs2_refresh_inode_from_lvb() to see what I'm
>> talking about. Since the lvb goes over the network we chose a big-endian
>> representation there.
>
> ocfs2_protocol_version has two variables, pv_major and pv_minor both of 
> which are u8 :) Perhaps I could put in a comment if you like.

Ok, I feel silly :) A comment doesn't hurt.

>>> +static int version_lock(struct ocfs2_cluster_connection *conn, int mode,
>>> +		int flags)
>>> +{
>>> +	struct ocfs2_live_connection *lc = conn->cc_private;
>>> +	return sync_lock(conn, mode, flags,
>>> +			&lc->oc_version_lksb, "version_lock");
>>> +}
>>
>> #define	VERSION_LOCK_NAME	"version_lock"
>>
>> and take the "name" argument out of sync_lock().
>> 	--Mark
>>
>
> Understood.

Thanks,
	--Mark

--
Mark Fasheh
