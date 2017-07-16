// This is an Unreal Script

class X2StatusEffects_Rebalanced extends X2StatusEffects config(GameCore);

var config int BETTER_DISORIENTED_TURNS;
var config int BETTER_DISORIENTED_MOBILITY_ADJUST;
var config int BETTER_DISORIENTED_AIM_ADJUST;
var config int BETTER_DISORIENTED_WILL_ADJUST;

var config int BETTER_DISORIENTED_HIERARCHY_VALUE;

// Extends the regular Disoriented Status Effect by adding a chance value similar to the Stunned effect. ApplyChance is defined in X2Effect.
static function X2Effect_PersistentStatChange CreateBetterDisorientedStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f, int Chance=100)
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local X2Condition_UnitProperty			UnitPropCondition;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = class'X2AbilityTemplateManager'.default.DisorientedName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	PersistentStatChangeEffect.BuildPersistentEffect(default.BETTER_DISORIENTED_TURNS,, false,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.DisorientedFriendlyName, default.DisorientedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.BETTER_DISORIENTED_MOBILITY_ADJUST);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.BETTER_DISORIENTED_AIM_ADJUST);
	PersistentStatChangeEffect.VisualizationFn = DisorientedVisualization;
	PersistentStatChangeEffect.EffectTickedVisualizationFn = DisorientedVisualizationTicked;
	PersistentStatChangeEffect.EffectRemovedVisualizationFn = DisorientedVisualizationRemoved;
	PersistentStatChangeEffect.EffectHierarchyValue = default.BETTER_DISORIENTED_HIERARCHY_VALUE;
	PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
	PersistentStatChangeEffect.bIsImpairingMomentarily = true;
	PersistentStatChangeEffect.DamageTypes.AddItem('Mental');
	PersistentStatChangeEffect.EffectAddedFn = DisorientedAdded;
	PersistentStatChangeEffect.DelayVisualizationSec = DelayVisualizationSec;

	PersistentStatChangeEffect.ApplyChance = Chance;

	if (default.DisorientedParticle_Name != "")
	{
		PersistentStatChangeEffect.VFXTemplateName = default.DisorientedParticle_Name;
		PersistentStatChangeEffect.VFXSocket = default.DisorientedSocket_Name;
		PersistentStatChangeEffect.VFXSocketsArrayName = default.DisorientedSocketsArray_Name;
	}

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
	UnitPropCondition.ExcludeRobotic = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

	return PersistentStatChangeEffect;
}