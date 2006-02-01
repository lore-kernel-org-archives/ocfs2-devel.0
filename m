From: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed, 1 Feb 2006 13:27:18 +0100
Subject: [Ocfs2-devel] [PATCH 00/11] ocfs2: implement userspace
	clustering interface
In-Reply-To: <20060110190847.GS3313@ca-server1.us.oracle.com>
References: <20060109223942.GA8721@locomotive.unixthugs.org>
	<20060110042959.GJ3313@ca-server1.us.oracle.com>
	<43C33D62.1000804@suse.com>
	<20060110104319.GU14816@marowsky-bree.de>
	<20060110190847.GS3313@ca-server1.us.oracle.com>
Message-ID: <20060201122718.GD28936@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2006-01-10T11:08:47, Mark Fasheh <mark.fasheh@oracle.com> wrote:

> > We don't have working user-space code for integrating with the new OCFS2
> > interface by Jeff yet :-( However, we've been working together to make
> > sure the interface is "right" for us to use - the good thing about the
> > new API is that in theory it can be driven from shell scripts for
> > testing w/no cluster involved at all ;-)
> Ok. Personally I'd like to see the beginnings of that before pushing your
> patch into our tree, but I think we're still at the early stages of review
> anyway.

Actually, I like forgot to post this here. I'm cross-posting to
linux-ha-dev for comments, too.

I'll once again summarize the approach we're taking for supporting
OCFS2; it falls apart into several steps:

1.) We allow the heartbeat groups to be controlled by, well,
heartbeat/CRM via a "clone" Resource Agent, and then perform
mounts/unmounts. o2cb is still used in this scheme to populate the node
tree. This implements the top/down approach - CRM controls OCFS2 mounts
completely - and is a pre-requisite to the next steps. All OCFS2 mounts
have to be configured in the CRM XML configuration like other
filesystems too.

(This step is coded; I'll go into it after the overview.)

1.5.) We have noticed that we want to restructure some calling
conventions of the Resource Agents for this case (amazing what you
notice when you actually go and _implement_ some grand design! ;-). But
this doesn't affect the general mechanism at all and is just mentioned
for completeness.


2.) "o2cb" is replaced; we auto-discover the IPs of participating nodes
and populate the node tree automatically as required. This removes the
need to configure & sync anything outside hb2 for OCFS2. Well; except
for calling mkfs once, somewhere.

(The filesystem will have to be told which NIC / label to use as part of
the configuration, though, but that's easy.)

3.) We hook into mount/umount so that when the admin issues such a manual
command for OCFS2, we call into the CRM and either instantiate an OCFS2
locally or umount it (and stop anything on top, if needed, at least if
invoked with -f).

4.) Follows logically from 3.: When the admin tries to mount a
filesystem which we don't know about yet (fsid not in our
configuration), we create the required object from a default template,
and then proceed as above. At this stage, mkfs/mount/umount will provide
the complete look & feel of a regular filesystem.


Further options we might then explore, mostly optimizations:

5.) Right now, the OCFS2 is driven via the regular Resource Agent
mechanism. That implies calling (exec) out to an external agent;
ultimately, I'd like to have a "fast" RA interface talking to a
pre-loaded plugin for efficiency. Again this is mostly an internal
optimization and doesn't really affect the overall design.

6.) Right now, OCFS2's node manager only allows a single cluster. We've
briefly toyed with the thought of having several, which then could use
independent network links for example for performance. Not sure whether
this is useful at all.


Going back to how step 1 is implemented now.

So, as any Cluster Manager, we already have the ability to mount/umount
filesystems of course. I went in and extended this to support our
"clones" (http://linux-ha.org/v2/Concepts/Clones) for use with OCFS2.
Clones are essentially regular resources, but which can be instantiated
more than once; and one can tell the system to provide the clones with
notifications when we do something to their instances on another nodes.

In particular, they get told where else in the cluster their instances
are running. So, what we have to do follows naturally from that, and I'm
quoting the comment in the code at you so I don't have to type it
twice:

	# Process notifications; this is the essential glue level for
	# giving user-space membership events to a cluster-aware
	# filesystem. Right now, only OCFS2 is supported.
	#
	# We get notifications from hb2 that some operation (start or
	# stop) has completed; we then (1) compare the list of nodes
	# which are active in the fs membership with the list of nodes
	# which hb2 wants to be participating and remove those which
	# aren't supposed to be around. And vice-versa, (2) we add nodes
	# which aren't yet members, but which hb2 _does_ want to be
	# active.
	#
	# Eventually, if (3) we figure that we ourselves are on the list
	# of nodes which weren't active yet, we initiate a mount
	# operation.
	#
	# That's it.
	#
	# This approach _does_ have the advantage of being rather
	# robust, I hope. We always re-sync the current membership with
	# the expected membership.
	#
	# Note that this expects that the base cluster is already
	# active; ie o2cb has been started and populated
	# $OCFS2_CLUSTER_ROOT/node/ already. This can be achieved by
	# simply having o2cb run on all nodes by the CRM too.  This
	# probably ought to be mentioned somewhere in the to be written
	# documentation. ;-)
	#

On "stop", we simply umount locally and then remove the heartbeat group
completely. On being notified of a "stop" from another node, the above
logic kicks in and will rempove the node from the heartbeat group.

So, this isn't that difficult, despite being implemented in bash. ;-)

Now, how does this look in the configuration for an 8 node cluster (or
actually, a scenario where you want 8 nodes to be able to mount the fs)?
XML haters beware - and remember that a) this is step 1, b) that it is
very close to how filesystems are configured regularly, and c) that
heartbeat does have a python GUI too:

<clone id="exp1" notify="1" notify_confirm="1">
  <instance_attributes>
    <attributes>
      <nvpair name="clone_max" value="8"/>
      <nvpair name="clone_node_max" value="1"/>
    </attributes>
  </instance_attributes>
  <primitive id="rsc2" class="ocf" type="Filesystem">
    <operations>
      <op id="dfs-op-1" interval="120s" name="monitor" timeout="60s"/>
      <op id="fs-op-2" interval="120s" name="notify" timeout="60s"/>
    </operations>
    <instance_attributes>
      <attributes>
        <nvpair id="fs-attr-1" name="device" value="/dev/sda1"/>
        <nvpair id="fs-attr-3" name="directory" value="/srv/www"/>
        <nvpair id="fs-attr-4" name="fstype" value="ocfs2"/>
      </attributes>
    </instance_attributes>
  </primitive>
</clone>

Just the "clone" object surrounding the Filesystem resource is new, plus
the "notify" operation (for which non-cluster filesystems have no use);
the rest is absolutely identical.

I'll test this code some more, and we're currently trying to push out
heartbeat 2.0.3 this week - so I can't go in and commit such a big
change to the Filesystem agent. But, this will appear early in 2.0.4,
probably after next week (I'm on "vacation" without network access)
then.

I've attached the diff to the Filesystem agent from my current
workspace. This is meant for illustration only; I've screwed up (ie,
deleted) my testbed and so it probably doesn't work because of typos
;-)


Sincerely,
    Lars Marowsky-Br?e

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-------------- next part --------------
Index: resources/OCF/Filesystem.in
===================================================================
RCS file: /home/cvs/linux-ha/linux-ha/resources/OCF/Filesystem.in,v
retrieving revision 1.14
diff -u -p -r1.14 Filesystem.in
--- resources/OCF/Filesystem.in	26 Jan 2006 18:00:05 -0000	1.14
+++ resources/OCF/Filesystem.in	1 Feb 2006 12:26:42 -0000
@@ -145,9 +145,31 @@ Any extra options to be given as -o opti
 </parameter>
 </parameters>
 
+<parameter name="ocfs2_cluster" unique="0">
+<longdesc lang="en">
+The name (UUID) of the OCFS2 cluster this filesystem is part of,
+iff this is an OCFS2 resource and there's more than one cluster. You
+should not need to specify this.
+</longdesc>
+<shortdesc lang="en">OCFS2 cluster name/UUID</shortdesc>
+<content type="string" default="" />
+</parameter>
+</parameters>
+
+<parameter name="ocfs2_configfs" unique="0">
+<longdesc lang="en">
+Mountpoint of the cluster hierarchy below configfs. You should not
+need to specify this.
+</longdesc>
+<shortdesc lang="en">OCFS2 configfs root</shortdesc>
+<content type="string" default="" />
+</parameter>
+</parameters>
+
 <actions>
 <action name="start" timeout="60" />
 <action name="stop" timeout="60" />
+<action name="notify" timeout="60" />
 <action name="status" depth="0" timeout="10" interval="10" start-delay="10" />
 <action name="monitor" depth="0" timeout="10" interval="10" start-delay="10" />
 <action name="validate-all" timeout="5" />
@@ -167,16 +189,10 @@ END
 #
 flushbufs() {
   if
-    [ "$BLOCKDEV" != "" -a -x "$BLOCKDEV" ]
+    [ "$BLOCKDEV" != "" -a -x "$BLOCKDEV" -a "$blockdevice" = "yes" ]
   then
-    case $1 in
-      -*|[^/]*:/*|//[^/]*/*)	# -U, -L options to mount, or NFS mount point,
-				# or samba mount point	
-			;;
-      *)		$BLOCKDEV --flushbufs $1
-			return $?
-			;;
-    esac
+    $BLOCKDEV --flushbufs $1
+    return $?
   fi
   
   return 0
@@ -187,6 +203,13 @@ flushbufs() {
 #
 Filesystem_start()
 {
+	if [ "$FSTYPE" = "ocfs2" ] && [ -z "$OCFS2_DO_MOUNT" ]; then
+		# Sorry, start doesn't actually do anything here. Magic
+		# happens in Filesystem_notify; see the comment there.
+		ocf_log debug "$DEVICE: ocfs2 - skipping start."
+		return $OCF_SUCCESS
+	fi		
+
 	# See if the device is already mounted.
 #$MOUNT | cut -d' ' -f3 | grep -e "^$MOUNTPOINT$" >/dev/null
 	Filesystem_status >/dev/null 2>&1
@@ -196,6 +219,8 @@ Filesystem_start()
 	fi
 
 	# Insert SCSI module
+	# TODO: This probably should go away. Why should the filesystem
+	# RA magically load a kernel module?
 	$MODPROBE scsi_hostadapter >/dev/null 2>&1
 
 	if [ -z $FSTYPE ]; then
@@ -222,7 +247,7 @@ Filesystem_start()
 
 	if
 	  case $FSTYPE in
-	    ext3|reiserfs|xfs|jfs|vfat|fat|nfs|cifs|smbfs)	false;;
+	    ext3|reiserfs|reiser4|nss|xfs|jfs|vfat|fat|nfs|cifs|smbfs|ocfs2)	false;;
 	    *)				true;;
 	  esac
         then
@@ -266,11 +291,154 @@ Filesystem_start()
 }
 # end of Filesystem_start
 
+Filesystem_notify() {
+	# Process notifications; this is the essential glue level for
+	# giving user-space membership events to a cluster-aware
+	# filesystem. Right now, only OCFS2 is supported.
+	#
+	# We get notifications from hb2 that some operation (start or
+	# stop) has completed; we then (1) compare the list of nodes
+	# which are active in the fs membership with the list of nodes
+	# which hb2 wants to be participating and remove those which
+	# aren't supposed to be around. And vice-versa, (2) we add nodes
+	# which aren't yet members, but which hb2 _does_ want to be
+	# active.
+	#
+	# Eventually, if (3) we figure that we ourselves are on the list
+	# of nodes which weren't active yet, we initiate a mount
+	# operation.
+	#
+	# That's it.
+	#
+	# If you wonder why we don't process pre-notifications, or don't
+	# do anything in "start": pre-start doesn't help us, because we
+	# don't get it on the node just starting. pre-stop doesn't help
+	# us either, because we can't remove any nodes while still
+	# having the fs mounted. And because we can't mount w/o the
+	# membership populated, we have to wait for the post-start
+	# event.
+	# 
+	# This approach _does_ have the advantage of being rather
+	# robust, I hope. We always re-sync the current membership with
+	# the expected membership.
+	#
+	# Note that this expects that the base cluster is already
+	# active; ie o2cb has been started and populated
+	# $OCFS2_CLUSTER_ROOT/node/ already. This can be achieved by
+	# simply having o2cb run on all nodes by the CRM too.  This
+	# probably ought to be mentioned somewhere in the to be written
+	# documentation. ;-)
+	#
+
+	if [ "$FSTYPE" != "ocfs2" ]; then
+		# One of the cases which shouldn't occur; it should have
+		# been caught much earlier. Still, you know ...
+		ocf_log err "$DEVICE: Notification received for non-ocfs2 mount."
+		return $OCF_ERR_GENERIC
+	fi
+
+	local n_type="$OCF_RESKEY_notify_type"
+	local n_op="$OCF_RESKEY_notify_operation"
+	local n_active="$OCF_RESKEY_notify_active_uname"
+
+	ocf_log debug "$OCFS2_UUID - notify: $n_type for $n_op - active on $n_active"
+
+	if [ "$n_type" != "post" ]; then
+		ocf_log debug "$OCFS2_UUID: ignoring pre-notify."
+		return $OCF_SUCCESS
+	fi
+
+	local n_myself=${HA_CURHOST:-$(uname -n | tr A-Z a-z)}
+	ocf_log debug "$OCFS2_UUID: I am node $n_myself."
+
+	case " $n_active " in
+	*" $n_myself "*) ;;
+	*)	ocf_log err "$OCFS2_UUID: $n_myself (local) not on active list!"
+		return $OCF_ERR_GENERIC
+		;;
+	esac
+
+	# (1)
+	if [ -d "$OCFS2_FS_ROOT" ]; then
+	entry_prefix=$OCFS2_FS_ROOT/
+	for entry in $OCFS2_FS_ROOT/* ; do
+		n_fs="${entry##$entry_prefix}"
+		ocf_log debug "$OCFS2_UUID: Found node $n_fs"
+		case " $n_active " in
+		*" $n_fs "*)
+			# Construct a list of nodes which are present
+			# already in the membership.
+			n_exists="$n_exists $n_fs"
+			ocf_log debug "$OCFS2_UUID: Keeping node: $n_fs"
+			;;
+		*)
+			# Node is in the membership currently, but not on our 
+			# active list. Must be removed.
+			if [ "$n_op" = "start" ]; then
+				ocf_log warn "$OCFS2_UUID: Removing nodes on start"
+			fi
+			ocf_log info "$OCFS2_UUID: Removing dead node: $n_fs"
+			if rm -f $entry ; then
+				ocf_log debug "$OCFS2_UUID: Removal of $n_fs ok."
+			else
+				ocf_log err "$OCFS2_UUID: Removal of $n_fs failed!"
+			fi
+			;;
+		esac
+	done
+	else
+		ocf_log info "$OCFS2_UUID: Doesn't exist yet, creating."
+		mkdir -p $OCFS2_UUID
+	fi
+
+	ocf_log debug "$OCFS2_UUID: Nodes which already exist: $n_exists"
+	
+	# (2)
+	for entry in $n_active ; do
+		ocf_log debug "$OCFS2_UUID: Expected active node: $entry"
+		case " $n_exists " in
+		*" $entry "*)
+			ocf_log debug "$OCFS2_UUID: Already active: $entry"
+			;;
+		*)
+			if [ "$n_op" = "stop" ]; then
+				ocf_log warn "$OCFS2_UUID: Adding nodes on stop"
+			fi
+			ocf_log info "$OCFS2_UUID: Activating node: $entry"
+			if ! ln -s $OCFS2_CLUSTER_ROOT/node/$entry $OCFS2_UUID/$entry ; then
+				ocf_log err "$OCFS2_CLUSTER_ROOT/node/$entry: failed to link"
+				# exit $OCF_ERR_GENERIC
+			fi
+			
+			if [ "$entry" = "$n_myself" ]; then
+				OCFS2_DO_MOUNT=yes
+				ocf_log debug "$OCFS2_UUID: To be mounted."
+			fi	
+			;;
+		esac
+	done
+
+	# (3)
+	# For now, always unconditionally go ahead; we're here, so we
+	# should have the fs mounted. In theory, it should be fine to
+	# only do this when we're activating ourselves, but what if
+	# something went wrong, and we're in the membership but don't
+	# have the fs mounted? Can this happen? TODO
+	OCFS2_DO_MOUNT="yes"
+	if [ -n "$OCFS2_DO_MOUNT" ]; then
+		Filesystem_start
+	fi
+}
+
 #
 # STOP: Unmount the filesystem
 #
 Filesystem_stop()
 {
+	# TODO: We actually need to free up anything mounted on top of
+	# us too, and clear nfs exports of ourselves; otherwise, our own
+	# unmount process may be blocked.
+	
 	# See if the device is currently mounted
 	if
 		Filesystem_status >/dev/null 2>&1
@@ -303,6 +471,7 @@ Filesystem_stop()
 		DEV=`$MOUNT | grep "on $MOUNTPOINT " | cut -d' ' -f1`
 		# Unmount the filesystem
 		$UMOUNT $MOUNTPOINT
+		rc=$?
 	    fi
 		if [ $? -ne 0 ] ; then
 			ocf_log err "Couldn't unmount $MOUNTPOINT"
@@ -313,7 +482,18 @@ Filesystem_stop()
 		: $MOUNTPOINT Not mounted.  No problema!
 	fi
 
-	return $?
+	# We'll never see the post-stop notification. We're gone now,
+	# have unmounted, and thus should remove the membership.
+	if [ "$FSTYPE" = "ocfs2" ]; then
+		if [ ! -d "$OCFS2_FS_ROOT" ]; then
+			ocf_log info "$OCFS2_FS_ROOT: Filesystem membership already gone."
+		else
+			ocf_log info "$OCFS2_FS_ROOT: Removing membership directory."
+			rm -rf $OCFS2_FS_ROOT/
+		fi
+	fi
+	
+	return $rc
 }
 # end of Filesystem_stop
 
@@ -339,6 +519,10 @@ Filesystem_status()
           msg="$MOUNTPOINT is unmounted (stopped)"
         fi
 
+	# TODO: For ocfs2, or other cluster filesystems, should we be
+	# checking connectivity to other nodes here, or the IO path to
+	# the storage?
+	
         case "$OP" in
 	  status)	ocf_log info "$msg";;
 	esac
@@ -383,6 +567,63 @@ Filesystem_validate_all()
 	return $OCF_SUCCESS
 }
 
+ocfs2_init()
+{
+	# Check & initialize the OCFS2 specific variables.
+	if [ -z "$OCF_RESKEY_clone_max" ]; then
+		ocf_log err "ocfs2 must be run as a clone."
+		exit $OCF_ERR_GENERIC
+	fi
+
+	if [ $blockdevice = "no" ]; then
+		ocf_log err "$DEVICE: ocfs2 needs a block device instead."
+		exit $OCF_ERR_GENERIC
+	fi
+	
+	for f in "$OCF_RESKEY_ocfs2_configfs" /sys/kernel/config/cluster /configfs/cluster ; do
+		if [ -n "$f" -a -d "$f" ]; then
+			OCFS2_CONFIGFS="$f"
+			ocf_log debug "$OCFS2_CONFIGFS: used as configfs root."
+			break
+		fi
+	done
+	if [ ! -d "$OCFS2_CONFIGFS" ]; then
+		ocf_log err "ocfs2 needs configfs mounted."
+		exit $OCF_ERR_GENERIC
+	fi
+
+	OCFS2_UUID=$(mounted.ocfs2 -d $DEVICE|tail -1|awk '{print $3}'|tr -d -- -|tr a-z A-Z)
+	if [ -z "$OCFS2_UUID" ]; then
+		ocf_log err "$DEVICE: Could not determine ocfs2 UUID."
+		exit $OCF_ERR_GENERIC
+	fi
+	
+	if [ -n "$OCF_RESKEY_ocfs2_cluster" ]; then
+		OCFS2_CLUSTER=$(echo $OCF_RESKEY_ocfs2_cluster | tr a-z A-Z)
+	else
+		OCFS2_CLUSTER=$(find /tmp -maxdepth 1 -mindepth 1 -type d 2>&1)
+		set -- $OCFS2_CLUSTER
+		local n="$#"
+		if [ $n -gt 1 ]; then
+			ocf_log err "$OCFS2_CLUSTER: several clusters found."
+			exit $OCF_ERR_GENERIC
+		fi
+		if [ $n -eq 0 ]; then
+			ocf_log err "$OCFS2_CONFIGFS: no clusters found."
+			exit $OCF_ERR_GENERIC
+		fi
+	fi
+	ocf_log debug "$DEVICE: using cluster $OCFS2_CLUSTER"
+
+	OCFS2_CLUSTER_ROOT="$OCFS2_CONFIGFS/$OCFS2_CLUSTER"
+	if [ ! -d "$OCFS2_CLUSTER_ROOT" ]; then
+		ocf_log err "$OCFS2_CLUSTER: Cluster doesn't exist. Maybe o2cb hasn't been run?"
+		exit $OCF_ERR_GENERIC
+	fi
+	
+	OCFS2_FS_ROOT=$OCFS2_CLUSTER_ROOT/heartbeat/$OCFS2_UUID
+}
+
 # Check the arguments passed to this script
 if
   [ $# -ne 1 ]
@@ -428,6 +669,17 @@ case $DEVICE in
 	;;
 esac
 
+if [ "$FSTYPE" = "ocfs2" ]; then
+	ocfs2_init
+else 
+	if [ -n "$OCF_RESKEY_clone_max" ]; then
+		ocf_log err "DANGER! $FSTYPE on $DEVICE is NOT cluster-aware!"
+		ocf_log err "DO NOT RUN IT AS A CLONE!"
+		ocf_log err "Politely refusing to proceed to avoid data corruption."
+		exit $OCF_ERR_GENERIC	
+	fi
+fi
+
 # It is possible that OCF_RESKEY_directory has one or even multiple trailing "/".
 # But the output of `mount` and /proc/mounts do not.
 if [ -z $OCF_RESKEY_directory ]; then
@@ -439,6 +691,8 @@ else
     MOUNTPOINT=$(echo $OCF_RESKEY_directory | sed 's/\/*$//')
     : ${MOUNTPOINT:=/}
     # At this stage, $MOUNTPOINT does not contain trailing "/" unless it is "/"
+    # TODO: / mounted via Filesystem sounds dangerous. On stop, we'll
+    # kill the whole system. Is that a good idea?
 fi
 	
 # Check to make sure the utilites are found
@@ -451,6 +705,8 @@ check_util $UMOUNT
 case $OP in
   start)		Filesystem_start
 			;;
+  notify)		Filesystem_notify
+			;;
   stop)			Filesystem_stop
 			;;
   status|monitor)	Filesystem_status
